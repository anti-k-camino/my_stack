shared_examples_for "Publishable" do
  it "publicate question in the channel" do
    expect(PrivatePub).to receive(:publish_to).with(path, anything)
    create_object
  end

  it "don't publicate question in the channel" do
    expect(PrivatePub).to_not receive(:publish_to).with(path, anything)
    invalid
  end
end