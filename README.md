# Sluggy
## Minimal slugging/permalink gem for ActiveRecord. Nothing fancy.

Built with rails 3.2 and ruby 1.9.2 in mind.

### Features

* Slug generation with sequence support.
* Slug validation.
* **40 LOC** & fully tested.

### Slug pattern

* downcase and strip
* remove non [a-z0-9-_]
* replace spaces with '-'
* if conflict add separator '--' with sequence number

### Validations

* Presence
* Format with Sluggy::SLUG_REGEX
* Length within 1..100
* Uniqueness

### Use like this

    slug_for :title
    slug_for :title, :column => :slug
    slug_for :title, :column => :slug, :scope => :account_id

Defaults are `:column => :permalink, :scope => nil`

### Install

    gem 'sluggy'

Copyright (c) 2012 Ary Djmal, released under the MIT license.
