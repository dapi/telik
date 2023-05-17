# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class TopicTitleBuilderTest < ActiveSupport::TestCase
  test 'template by default' do
    visitor = visitors :yandex
    visit = visits :yandex
    assert_equal TopicTitleBuilder.new.build_topic(visitor, visit), '#734930554 Danil Pismenny Cheboksary (Chuvashia/RU)'
  end

  test 'custom template' do
    visitor = visitors :yandex
    visit = visits :yandex
    visitor.project.topic_title_template = '%{user_data.user_id} %{page_data.product_id} %{visit_data.products_in_cart_count} [%{user_data.no_key}]'
    assert_equal TopicTitleBuilder.new.build_topic(visitor, visit), '123 2 1 []'
  end
end
