all blog posts:

<ul>
<$list filter="[tag[blog]]">
<li>
<$link to={{!!title}}><$view field="title"/></$link><br>
<$list filter="[all[current]tags[]![Reports]sort[]]" template="$:/core/ui/TagTemplate"></$list>
</li>
</$list>
</ul>