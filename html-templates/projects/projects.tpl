{extends designs/site.tpl}

{block title}{_ "Projects"} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "features/sidebar-tags.js"}
{/block}

{block content}
    <header class="page-header">
        <div class="btn-toolbar pull-right">
            {if $.User}
                <form action="/projects/create">
                    <button class="btn btn-success" type="submit">{glyph "plus"}&nbsp;{_ "Add Project&hellip;"}</button>
                </form>
            {else}
                <a href="/register" class="btn btn-danger">{glyph "fire"}&nbsp;{_ "Register with the Brigade!"}</a>
            {/if}
        </div>
        <h1>{_ "Civic Projects Directory"} <span class="badge">{$projectsTotal|number_format}</span></h1>
    </header>

    {contentBlock "projects-browse-introduction"}

    <div class="row">
        <div class="col-sm-4 col-md-3 tags-ct">
            <div class="btn-group btn-group-justified btn-group-xs margin-bottom" role="group">
                <a href="#projects-by-topic" class="active btn btn-default" role="button" data-group="byTopic">{_ "topics"}</a>
                <a href="#projects-by-tech" class="btn btn-default" role="button" data-group="byTech">{_ "tech"}</a>
                <a href="#projects-by-event" class="btn btn-default" role="button" data-group="byEvent">{_ "events"}</a>
                <a href="#projects-by-event" class="btn btn-default" role="button" data-group="byStage">{_ "stages"}</a>
            </div>

            {template tagLink tagData rootUrl linkCls=""}
                <a class="{$linkCls}" href="{$rootUrl}?tag={$tagData.Handle}">{$tagData.Title}{if $tagData.itemsCount} <span class="badge pull-right">{$tagData.itemsCount|number_format}</span>{/if}</a>
            {/template}

            <div class="tags list-group byTopic">
                {foreach item=tag from=$projectsTags.byTopic}
                    {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                {/foreach}
            </div>
            <div class="tags list-group byTech" style="display: none">
                {foreach item=tag from=$projectsTags.byTech}
                    {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                {/foreach}
            </div>
            <div class="tags list-group byEvent" style="display: none">
                {foreach item=tag from=$projectsTags.byEvent}
                    {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                {/foreach}
            </div>
            <div class="tags list-group byStage" style="display: none">
                {foreach item=stage from=$projectsStages}
                    <a class="list-group-item" href="/projects?stage={$stage.Stage}">{$stage.Stage} <span class="badge pull-right">{$stage.itemsCount|number_format}</span></a>
                {/foreach}
            </div>
        </div>
        <div class="col-sm-8 col-md-9">
            {foreach item=Project from=$data}
                <article class="post card">
                    <div class="card-block">
                        <h2 class="post-title">
                            <a name="{$Project->Handle}" href="{$Project->getURL()}">{$Project->Title|escape}</a>
                            {if $Project->Stage}
                                <span class="badge badge-info">{_ "$Project->Stage"}</span>
                            {/if}
                        </h2>
                        <div class="well">
                            {if $Project->README}
                                <div class="content-markdown content-readme">{$Project->README|truncate:600|escape|markdown}</div>
                            {/if}
                        </div>
                        {if $Project->Memberships}
                            <ul class="list-inline people-list">
                            {foreach item=Membership from=$Project->Memberships}
                                {$Member = $Membership->Member}
                                <li class="list-inline-item people-list-person {tif $Project->MaintainerID == $Member->ID ? maintainer}">
                                    <a
                                        href="/members/{$Member->Username}"
                                        class="member-thumbnail"
                                        data-toggle="tooltip"
                                        title="{personName $Member} &mdash; {projectMemberTitle $Membership}"
                                    >
                                        {if $Project->MaintainerID == $Member->ID}
                                            {avatar $Member size=64}
                                        {else}
                                            {avatar $Member size=48}
                                        {/if}
                                    </a>
                                </li>
                            {foreachelse}
                                <li class="muted list-inline-item">{_ "No registered members"}</li>
                            {/foreach}
                            </ul>
                        {/if}
                        <div class="btn-group post-link-group" role="group">
                            {if $Project->UsersUrl}<a class="btn btn-primary" role="button" href="{$Project->UsersUrl|escape}">{glyph "link"}&nbsp;Public Site</a>{/if}
                            {if $Project->DevelopersUrl}<a class="btn btn-success" role="button" href="{$Project->DevelopersUrl|escape}">{glyph "link"}&nbsp;Developers</a>{/if}
                        </div>
                    </div>
                </article>
            {foreachelse}
                <em>No projects were found, try creating one{if count($conditions)} or <a href="?">browse without any filters</a>{/if}.</em>
            {/foreach}
        </div>
    </div>
{/block}
