require 'spec_helper'

describe PlaylistsController do
  # This should return the minimal set of attributes required to create a valid
  # Playlist. As you add validations to Playlist, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "user" => "" }
  end

  describe 'GET index' do
    before do
      @playlist = Playlist.create! valid_attributes
      controller.index
    end
    describe 'assigns all playlists as @playlists' do
      subject { controller.instance_variable_get('@playlists') }
      it { should eq([@playlist]) }
    end
  end

  describe 'GET show' do
    before do
      @playlist = Playlist.create! valid_attributes
      controller.show(@playlist.to_param)
    end
    describe 'assigns the requested playlist as @playlist' do
      subject { controller.instance_variable_get('@playlist') }
      it { should eq(@playlist) }
    end
  end

  describe 'GET new' do
    before do
      controller.new
    end
    describe 'assigns a new playlist as @playlist' do
      subject { controller.instance_variable_get('@playlist') }
      it { should be_a_new(Playlist) }
    end
  end

  describe 'GET edit' do
    before do
      @playlist = Playlist.create! valid_attributes
      controller.edit(@playlist.to_param)
    end
    describe 'assigns the requested playlist as @playlist' do
      subject { controller.instance_variable_get('@playlist') }
      it { should eq(@playlist) }
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      before do
        controller.should_receive(:redirect_to) {|u| u.should eq(Playlist.last) }
      end
      describe 'creates a new Playlist' do
        it { expect {
          controller.create(valid_attributes)
        }.to change(Playlist, :count).by(1) }
      end

      describe 'assigns a newly created playlist as @playlist and redirects to the created playlist' do
        before do
          controller.create(valid_attributes)
        end
        subject { controller.instance_variable_get('@playlist') }
        it { should be_a(Playlist) }
        it { should be_persisted }
      end
    end

    context 'with invalid params' do
      describe "assigns a newly created but unsaved playlist as @playlist, and re-renders the 'new' template" do
        before do
          Playlist.any_instance.stub(:save) { false }
          controller.should_receive(:render).with(:action => 'new')
          controller.create({ "user" => "invalid value" })
        end
        subject { controller.instance_variable_get('@playlist') }
        it { should be_a_new(Playlist) }
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      describe 'updates the requested playlist, assigns the requested playlist as @playlist, and redirects to the playlist' do
        before do
          @playlist = Playlist.create! valid_attributes
          controller.should_receive(:redirect_to).with(@playlist, anything)
          controller.update(@playlist.to_param, valid_attributes)
        end
        subject { controller.instance_variable_get('@playlist') }
        it { should eq(@playlist) }
      end
    end

    context 'with invalid params' do
      describe "assigns the playlist as @playlist, and re-renders the 'edit' template" do
        before do
          @playlist = Playlist.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Playlist.any_instance.stub(:save) { false }
          controller.should_receive(:render).with(:action => 'edit')
          controller.update(@playlist.to_param, { "user" => "invalid value" })
        end
        subject { controller.instance_variable_get('@playlist') }
        it { should eq(@playlist) }
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @playlist = Playlist.create! valid_attributes
      controller.stub(:playlists_url) { '/playlists' }
      controller.should_receive(:redirect_to).with('/playlists')
    end
    it 'destroys the requested playlist, and redirects to the playlists list' do
      expect {
        controller.destroy(@playlist.to_param)
      }.to change(Playlist, :count).by(-1)
    end
  end
end
