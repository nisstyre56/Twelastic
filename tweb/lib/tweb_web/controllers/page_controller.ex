defmodule TwebWeb.PageController do
  use TwebWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
