shared_examples_for 'Renderable templates' do |template|
  it 'renders template' do
    do_request
    expect(response).to render_template template
  end
end