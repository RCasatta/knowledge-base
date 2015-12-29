---
layout: default
title: Projects
permalink: /projects/
---

{% capture projects %}
  {% for current in site.data.properties %}
    {% assign array = current[0] | split:'/' %}
      {% if array[1] == 'projects' %}
        {{ current[0] }}
      {% endif %}
  {% endfor %}
{% endcapture %}

{% assign sortedprojects = projects | split:' ' | sort %}

<div class="home">


  <h1 class="page-heading">Projects</h1>
  <ul>
    {% for key in sortedprojects %}
    {% assign project = site.data.properties[key] %}
      <li>
        <a href="{{ key | prepend: site.baseurl }}">
          {{ project.title }}
        </a>
      </li>
    {% endfor %}
  </ul>

</div>
