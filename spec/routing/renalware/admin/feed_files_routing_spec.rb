describe "Retired feed file uploads" do
  it "does not expose listing, upload, or file detail routes" do
    expect(get: "/admin/feeds/files").not_to be_routable
    expect(get: "/admin/feeds/files/new").not_to be_routable
    expect(get: "/admin/feeds/files/1").not_to be_routable
    expect(post: "/admin/feeds/files").not_to be_routable
  end
end
