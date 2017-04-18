defmodule TelnyxOmegaPricing.PageController do
  use TelnyxOmegaPricing.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
