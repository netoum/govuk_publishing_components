require "rails_helper"

describe "Search", type: :view do
  def component_name
    "search"
  end

  it "renders a search box with default options" do
    render_component({})
    assert_select ".gem-c-search.gem-c-search--on-white"
    assert_select "label[class^='govuk-\!-margin-bottom-']", count: 0
  end

  it "renders a search box for a dark background" do
    render_component(on_govuk_blue: true)
    assert_select ".gem-c-search.gem-c-search--on-govuk-blue"
  end

  it "doesn't render a search box for a dark background if the parameter is invalid" do
    render_component(on_govuk_blue: "dummy")
    assert_select ".gem-c-search.gem-c-search--on-govuk-blue", false
  end

  it "renders a search box with a custom label text" do
    render_component(label_text: "This is my new label")
    assert_select ".gem-c-search .gem-c-search__label", text: "This is my new label"
  end

  it "renders a search box with a custom label content" do
    render_component(inline_label: false, label_text: "This is a heading 1")
    assert_select ".gem-c-search .gem-c-search__label", text: "This is a heading 1"
    assert_select ".gem-c-search.gem-c-search--separate-label"
  end

  it "renders a search box with a value" do
    render_component(value: "I searched for this")
    assert_select ".gem-c-search .gem-c-search__input" do
      assert_select "[value=?]", "I searched for this"
    end
  end

  it "renders a search box with a custom id" do
    render_component(id: "my-unique-id")
    assert_select ".gem-c-search #my-unique-id.gem-c-search__input"
  end

  it "renders a large search box" do
    render_component(size: "large")
    assert_select ".gem-c-search.gem-c-search--large"
  end

  it "renders a large search box on mobile only" do
    render_component(size: "large-mobile")
    assert_select ".gem-c-search.gem-c-search--large-on-mobile"
  end

  it "renders a search box with a default name" do
    render_component({})
    assert_select 'input[name="q"]'
  end

  it "renders a search box with a custom name" do
    render_component(name: "my_custom_field")
    assert_select 'input[name="my_custom_field"]'
  end

  it "renders a search box with the aria-controls attribute" do
    render_component(aria_controls: "something-else")
    assert_select "input[aria-controls='something-else']"
  end

  it "renders a search box with custom margins" do
    render_component(
      margin_top: 3,
      margin_bottom: 2,
    )
    assert_select '.gem-c-search.govuk-\!-margin-top-3.govuk-\!-margin-bottom-2'
  end

  it "renders a search box with no border" do
    render_component(no_border: true)
    assert_select ".gem-c-search--no-border"
  end

  it "renders a search box with default button text" do
    render_component({})
    assert_select ".gem-c-search__submit", text: "Search"
  end

  it "renders a search box with custom button text" do
    render_component(button_text: "Search please")
    assert_select ".gem-c-search__submit", text: "Search please"
  end

  it "applies data attributes when provided" do
    render_component(
      button_text: "Some test text",
      data_attributes: {
        track_category: "track-category",
        track_action: "track-action",
        track_label: "track-label",
      },
    )

    assert_select '.gem-c-search__submit[data-track-category="track-category"]'
    assert_select '.gem-c-search__submit[data-track-action="track-action"]'
    assert_select '.gem-c-search__submit[data-track-label="track-label"]'
  end

  it "renders the correct label size" do
    render_component(label_size: "xl")
    assert_select ".govuk-label.govuk-label--xl", text: "Search on GOV.UK"
    assert_no_selector ".gem-c-search__label"
  end

  it "renders the default label when given an incorrect t-shirt size" do
    render_component(label_size: "super-massive-size")
    assert_no_selector ".govuk-label"
    assert_select ".gem-c-search__label", text: "Search on GOV.UK"
  end

  it "renders the default label when given no label size" do
    render_component({})
    assert_no_selector ".govuk-label"
    assert_select ".gem-c-search__label", text: "Search on GOV.UK"
  end

  it "renders with `enterkeyhint` attributes on both input and button by default" do
    render_component({})
    assert_select "input[enterkeyhint='search']", count: 1
    assert_select "button[enterkeyhint='search']", count: 1
  end

  it "has the correct label margin" do
    render_component({
      inline_label: false,
      label_margin_bottom: 9,
    })
    assert_select 'label.govuk-\!-margin-bottom-9', count: 1
  end

  it "doesn't set a margin override if label_margin_bottom set to 0" do
    render_component({
      inline_label: false,
      label_margin_bottom: 0,
    })
    assert_select 'label.govuk-\!-margin-bottom-0', count: 0
  end

  it "defaults to no bottom margin if an incorrect value is passed" do
    render_component({
      inline_label: false,
      margin_bottom: 20,
    })
    assert_select "label[class^='govuk-\!-margin-bottom-']", count: 0
  end

  it "defaults to no bottom margin if inline_label is not passed" do
    render_component({
      margin_bottom: 2,
    })
    assert_select "label[class^='govuk-\!-margin-bottom-']", count: 0
  end

  it "wraps the label in a heading level 2 by default" do
    render_component({
      wrap_label_in_a_heading: true,
    })
    assert_select 'h2.govuk-\!-margin-0 > label', count: 1
  end

  it "wraps the label in the set heading level" do
    render_component({
      wrap_label_in_a_heading: true,
      heading_level: 6,
    })
    assert_select 'h6.govuk-\!-margin-0 > label', count: 1
  end
end
