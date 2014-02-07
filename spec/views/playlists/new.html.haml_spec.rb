require 'spec_helper'

describe "playlists/new" do
  before(:each) do
    assign(:playlist, stub_model(Playlist,
      :user => nil,
      :name => "MyString",
      :playlist => nil
    ).as_new_record)
  end

  it "renders new playlist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", playlists_path, "post" do
      assert_select "input#playlist_user[name=?]", "playlist[user]"
      assert_select "input#playlist_name[name=?]", "playlist[name]"
      assert_select "input#playlist_playlist[name=?]", "playlist[playlist]"
    end
  end
end
