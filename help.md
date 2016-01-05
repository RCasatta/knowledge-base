---
layout: page
title: Help
permalink: /help/
---

In the knowledge base there are **two kind** of objects:

## Entities
Entities are **atemporal** objects, they could have types:

* People
* Projects
* Areas

They are files stored in the site root or in a subdirectory. The following file `riccardo.casatta.md` is an example.

{% highlight html %}
---
layout: people
title: Riccardo Casatta
---

Free text with markdown
{% endhighlight %}

Since it is stored int the `people` folder the permalink is `/people/riccardo.casatta.md`. This is used also as **identifier** of the entity.


## Facts
Facts happens in a **specific date**, they contains **relations** between entities.

They are files stored in the `_posts` directory with a **naming convention** `:year-:month-:day-:title`. The initial date is the happening date of the fact. `:title` is in lowercase and use dash instead of spaces.

There are also special properties that are optionally specificable in the front matter, especially the `relations` property.

{% highlight html %}
---
layout: post
title:  "New company 'Flusso di Blocchi' founded"
date:   2013-09-25 16:31:32 +0100
relations:
   - subject: [ /people/adamo.indietro/, /people/matteo.corallo/, /people/gregorio.massimobene/  ]
     verb: found
     object: [ /company/flusso.di.blocchi/ ]
---

{% endhighlight %}


`subject` and `object` are arrays of identifiers of entitites. All of the entities referenced in the relations property are shown in the respective entities.
