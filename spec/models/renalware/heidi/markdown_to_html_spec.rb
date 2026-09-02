describe Renalware::Heidi::MarkdownToHtml do
  it "converts common markdown into sanitized HTML suitable for Trix" do
    html = described_class.new(
      <<~MARKDOWN
        # Assessment

        **CKD** stable.
        Continue current treatment.

        - Check ACR
        - Review in *3 months*

        1. Arrange bloods
        2. Send letter
      MARKDOWN
    ).call

    expect(html).to include("<p><strong>Assessment</strong></p>")
    expect(html).to include("<p><strong>CKD</strong> stable.<br>Continue current treatment.</p>")
    expect(html).to include("<ul>")
    expect(html).to include("<li>Check ACR</li>")
    expect(html).to include("<li>Review in <em>3 months</em>")
    expect(html).to include("<ol>")
    expect(html).to include("<li>Arrange bloods</li>")
    expect(html).to include("<li>Send letter</li>")
  end

  it "escapes unsafe HTML before returning the converted note" do
    html = described_class.new("Hello <script>alert('x')</script>").call

    expect(html).to eq("<p>Hello &lt;script&gt;alert('x')&lt;/script&gt;</p>")
  end
end
