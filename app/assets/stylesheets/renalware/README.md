# CSS

The css or scss files in this top-level folder will be compiled and linked
by sprockets 4 as individually downloadble css assets (as .css and .css.gz files).

core.scss is the main css file which imports other .scss files in
./partials and ./modules, and includes css assets from external gem dependencies.

The other css files mainly relate to pdf processing and are required because
of the way wicked_pdf and the wkhtmltopdf process handle (ie inlining) css.
If we replaced wkhtmltopdf with prawn for example, these css files would not be
required.

watermark.css is required by both pdf and html rendering which is why its a separate thing.

See also e.g. https://github.com/rails/sprockets#link_directory
