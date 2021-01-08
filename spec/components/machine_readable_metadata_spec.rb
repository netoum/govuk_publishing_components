require "rails_helper"

describe "Machine readable metadata", type: :view do
  def component_name
    "machine_readable_metadata"
  end

  it "generates machine readable JSON-LD for articles" do
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "generic")
    render_component(content_item: example, schema: :article)

    json_linked_data = Nokogiri::HTML(rendered).css("script").text

    assert JSON.parse(json_linked_data)
  end

  it "generates machine readable JSON-LD for people" do
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "person")
    render_component(content_item: example, schema: :person)

    json_linked_data = Nokogiri::HTML(rendered).css("script").text

    assert JSON.parse(json_linked_data)
  end

  it "uses images if available" do
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "news_article") do |item|
      item["details"]["image"] = {
        "url" => "https://example.org/low-res.jpg",
      }
      item
    end

    render_component(content_item: example, schema: :article)

    assert_meta_tag "twitter:image", "https://example.org/low-res.jpg"
  end

  it "uses high resolution images if available" do
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "news_article") do |item|
      item["details"]["image"] = {
        "url" => "https://example.org/low-res.jpg",
        "high_resolution_url" => "https://example.org/high-res.jpg",
      }
      item
    end

    render_component(content_item: example, schema: :article)

    assert_meta_tag "twitter:image", "https://example.org/high-res.jpg"
  end

  it "generates machine readable JSON-LD for finders" do
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "finder")
    render_component(content_item: example, schema: :search_results_page)

    json_linked_data = Nokogiri::HTML(rendered).css("script").text

    assert JSON.parse(json_linked_data)
  end

  it "escapes harmful HTML in the JSON" do
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "generic")
    example["description"] = bad_html

    render_component(content_item: example, schema: :article)
    json_linked_data = Nokogiri::HTML(rendered).css("script").text

    assert_equal escaped_html, JSON.parse(json_linked_data)["description"]
  end

  it "escapes harmful HTML nested several layers inside the JSON" do
    allow(GovukPublishingComponents::Presenters::SchemaOrg).to receive(:new)
      .and_return(double("SchemaOrg", structured_data: {
        "foo" => {
          "bar" => bad_html,
        },
      }))
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: "generic")

    render_component(content_item: example, schema: :article)
    json_linked_data = Nokogiri::HTML(rendered).css("script").text

    assert_equal escaped_html, JSON.parse(json_linked_data)["foo"]["bar"]
  end

  def assert_meta_tag(name, content)
    assert_select "meta[name='#{name}'][content='#{content}']"
  end

  def bad_html
    "<script>alert('hi')</script>"
  end

  def escaped_html
    "\u003cscript\u003ealert('hi')\u003c/script\u003e"
  end
end
