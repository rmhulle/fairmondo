#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module ApplicationHelper

  def title(title = nil)
    if title.present?
      content_for :title, title
    else
      content_for?(:title) ? content_for(:title) + t('article.show.title_addition') : t('common.fairnopoly')
    end
  end

  def meta_keywords(tags = nil)
    if tags.present?
      content_for :meta_keywords, tags
    else
      content_for?(:meta_keywords) ? [content_for(:meta_keywords), t('meta_tags.keywords')].join(', ') : t('meta_tags.keywords')
    end
  end

  def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    else
      content_for?(:meta_description) ? content_for(:meta_description) : t('meta_tags.description')
    end
  end

  def truncate_and_sanitize_without_linebreaks(text = "", length = 70, omission ='', separator = ' ')
      truncate(Sanitize.clean(text), length: length, separator: separator, omission: omission ).gsub("\n", ' ')
  end

  # Login form anywhere - https://github.com/plataformatec/devise/wiki/How-To:-Display-a-custom-sign_in-form-anywhere-in-your-app
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Rails 4 included feature
  def cache_if (condition, name = {}, &block)
    if condition
      cache(name, &block)
    else
      yield
    end
  end

  # CSS Layout helper
  # By default will render css from controller/NAME_OF_THE_CONTROLLER.css
  # overwrite if you need somehing else
  def controller_specific_css_path
    @controller_specific_css ||= controller_name
    "controller/#{@controller_specific_css}.css"
  end

  ### Forms

  # Default input field value -> param or current_user.*
  # @api public
  # @param field [Symbol]
  # @return [String, nil]
  def default_form_value field, target = current_user
    default_value(field) || target.send(field)
  end

  # Default input field value -> param or nil
  # @api public
  # @param field [Symbol]
  # @return [String, nil]
  def default_value field
    if params['business_transaction'] && params['business_transaction'][field]
      params['business_transaction'][field]
    else
      nil
    end
  end

  def resource
    @controlled_resource ||= instance_variable_get("@#{controller_name.classify.underscore}")
  end

  def semantic_relation_field_for form, key, relation, &block
    form.semantic_fields_for key do |fields|
      res = relation.each do |item|
        fields.semantic_fields_for item.id.to_s.to_sym , item do |item_fields|
          capture(item, item_fields, &block)
        end

      end
      debugger
        res
    end

  end

end
