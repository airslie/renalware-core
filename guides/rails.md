# Rails Style Guide

## Controllers

- explicitly pass local vars to view/templates (see http://thepugautomatic.com/2013/05/locals/)

# ActiveRecord

- validate on objects not ID's
  - good `validates :description, presence: true`
  - bad `validates :description_id, presence: true`
  - [Reference](https://youtu.be/yuh9COzp5vo?t=17m45s)

- Arel/ActiveRecord query interface should be exposed via intention revealing methods on ActiveRecord model or a QueryObject. Exceptions are:

  - include (which can be used in controllers) to avoid n+1 queries
