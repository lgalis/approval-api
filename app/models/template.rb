=begin
Insights Service Approval APIs

APIs to query approval service

OpenAPI spec version: 1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git

=end


class Template < ApplicationRecord
  acts_as_tenant(:tenant, :has_global_records => true)

  has_many :workflows

  validates :title, :presence => :title

  def self.seed
    template = find_or_create_by!(:title => 'Basic')
    template.update_attributes(
      :description => 'A basic approval workflow that supports multi-level approver groups through email notification',
      :ext_ref     => 'containers/ApprovalService/processes/BasicEmail'
    )
  end
end
