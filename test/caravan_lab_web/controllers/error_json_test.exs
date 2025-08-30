defmodule CaravanLabWeb.ErrorJSONTest do
  use CaravanLabWeb.ConnCase, async: true

  test "renders 404" do
    assert CaravanLabWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert CaravanLabWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
