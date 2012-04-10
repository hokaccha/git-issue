# -*- coding: utf-8 -*-
require 'lighthouse'

module GitIssue
class GitIssue::Lighthouse < GitIssue::Base
  def initialize(args, options = {})
    super(args, options)

    # TODO use pit
    @account = configured_value('account')
    @token = configured_value('token')
    @project = configured_value('project')

    configure_error('account', 'git config issue.account <account>')  if @account.blank?
    configure_error('token', 'git config issue.token <token>')  if @token.blank?
    configure_error('project', 'git config issue.project <project_id>')  if @project.blank?

    ::Lighthouse.account = @account
    ::Lighthouse.token = @token
  end

  def list(options = {})
    issues = ::Lighthouse::Ticket.find(:all, :params => {
      :project_id => @project,
      :q => 'state:open',
    })

    s_max = issues.map{|i| mlength(i.state)}.max
    t_max = issues.map{|i| mlength(i.title)}.max
    m_max = issues.map{|i| mlength(i.milestone_title? || 'none')}.max
    u_max = issues.map{|i| mlength(i.assigned_user_name || '--')}.max

    issues.each do |issue|
      puts sprintf('#%-4d %s %s  %s  %s',
        issue.number.to_i,
        mljust("[#{issue.state}]", s_max + 2),
        mljust(issue.title, t_max),
        mljust(issue.milestone_title? || 'none', m_max),
        mljust(issue.assigned_user_name || '--', u_max),
      )
    end
  end
end
end
