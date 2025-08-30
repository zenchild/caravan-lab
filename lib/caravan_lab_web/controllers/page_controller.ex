defmodule CaravanLabWeb.PageController do
  use CaravanLabWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
