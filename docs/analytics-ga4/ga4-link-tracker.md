# Google Analytics 4 link tracker

This script is intended for adding GA4 tracking to links. It depends upon the main GA4 analytics code to function.

## Basic use (single link)

```html
<a
  href="/link"
  data-module="ga4-link-tracker"
  data-ga4-link='{ "event_name": "navigation", "type": "home page", "index": 0, "index_total": 1, "section": "name of section" }'>
    Link
</a>
```

Note that the specific detail of the `data-ga4-link` attribute will depend on the context of the link.

## Basic use (multiple links)

Specific tracking can be applied to multiple elements within a container, by applying the data module once to the parent element.

```html
<div data-module="ga4-link-tracker">
  <a
    href="/a-page"
    data-ga4-link='{ "event_name": "navigation", "type": "browse", "index": "0", "index_total": "2", "section": "name of section" }'>
    Link 1
  </a>
  <a
    href="/another-page"
    data-ga4-link='{ "event_name": "navigation", "type": "browse", "index": "1", "index_total": "2", "section": "name of section" }'>
    Link 2
  </a>
</div>
```

Note that the specific detail of the `data-ga4-link` attribute will depend on the context of the link.

## Basic use (override text)

The text of the link can be overridden by another value if passed in the data attribute, as shown.

```html
<a
  href="/link"
  data-module="ga4-link-tracker"
  data-ga4-link='{ "event_name": "navigation", "type": "home page", "index": 0, "index_total": 1, "section": "name of section", "text": "This text will be recorded in the GA event" }'>
    This text will not be recorded
</a>
```

## Track links within content

Where tracking attributes cannot be directly applied to elements, links can be tracked with details applied to the parent. In this configuration the link text and href are automatically determined and included in the event data. This is helpful where page content is not editable, e.g. content comes from the content item or a publishing tool.

The `data-ga4-track-links-only` attribute ensures that only link clicks are tracked (without it, any click inside the element is tracked).

```html
<div
  data-module="ga4-link-tracker"
  data-ga4-link='{ "event_name": "navigation", "type": "browse", "section": "name of section" }'
  data-ga4-track-links-only
  data-ga4-set-indexes>
  <a href="/link1">This link will be tracked</a>
  <a href="/link2">
    <span>This link will also be tracked even though it contains child elements</span>
  </a>
  <span>This span will not be tracked</span>
</div>
```

Note: the addition of the `data-ga4-set-indexes` data attribute on the parent element will allow the `index` and `index_total` properties to be set.

## Track links within content within a specific element

To apply tracking to links within a specific element within part of a page, use the `data-ga4-limit-to-element-class` alongside the `data-ga4-track-links-only` attribute. This is helpful where page content is not editable, e.g. content comes from the content item or a publishing tool.

```html
<div
  data-module="ga4-link-tracker"
  data-ga4-link='{ "event_name": "navigation", "type": "browse", "section": "name of section" }'
  data-ga4-track-links-only
  data-ga4-limit-to-element-class="demoBox">
  <a href="/link1">This link will not be tracked</a>
  <div class="demoBox">
    <a href="/link2">This link will be tracked</a>
  </div>
</div>
```

## Using the link tracker on components

Where possible, link tracking is optional for components in order to provide flexibility where different types of tracking might overlap. To track links within a component (e.g. contextual breadcrumbs), use the `ga4_tracking` option as shown:

```erb
<%= render 'govuk_publishing_components/components/contextual_breadcrumbs', {
  ga4_tracking: true,
  items: []
} %>
```
