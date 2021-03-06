# frozen_string_literal: true

module Decidim
  class ProfileSidebarCell < Decidim::ProfileCell
    include Decidim::Messaging::ConversationHelper
    include Decidim::IconHelper
    include Decidim::ViewHooksHelper
    include Decidim::ApplicationHelper

    helper_method :profile_user, :logged_in?, :current_user

    delegate :user_signed_in?, to: :controller

    def show
      render :show
    end

    private

    def logged_in?
      current_user.present?
    end

    def profile_user
      @profile_user ||= present(model)
    end

    def can_contact_user?
      !current_user || (current_user && current_user != model && profile_user.can_be_contacted?)
    end

    def officialization_text
      profile_user.officialization_text
    end

    def can_edit_user_group_profile?
      return false unless current_user
      return false if model.is_a?(Decidim::User)
      Decidim::UserGroups::ManageableUserGroups.for(current_user).include?(model)
    end

    def profile_user_can_follow?
      profile_user.can_follow?
    end

    def can_join_user_group?
      return false unless current_user
      return false if model.is_a?(Decidim::User)
      Decidim::UserGroupMembership.where(user: current_user, user_group: model).empty?
    end
  end
end
