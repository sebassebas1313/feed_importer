class FeedsController < ActionController::Base
  def import
    link = params[:link]

    Importers::RssFeed.new.call(link)
    render status: :ok, json: { message: 'import successfully' }
  rescue StandardError => _e
    # ideally log error with e.message
    # render status: :internal_server_error, json: { error: e.messsage }
    render status: :internal_server_error, json: { error: 'feed could not be imported' }
  end
end
