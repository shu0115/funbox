require 'spec_helper'

describe "playlists/edit" do
  before(:each) do
    @playlist = assign(:playlist, stub_model(Playlist,
      :user => nil,
      :name => "MyString",
      :playlist => nil
    ))
  end

  it "renders the edit playlist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", playlist_path(@playlist), "post" do
      assert_select "input#playlist_user[name=?]", "playlist[user]"
      assert_select "input#playlist_name[name=?]", "playlist[name]"
      assert_select "input#playlist_playlist[name=?]", "playlist[playlist]"
    end
  end
end
