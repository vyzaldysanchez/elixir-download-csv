defmodule App.Router.AppRouter do
  use App.Router
  use Plug.Builder

  require EEx

  EEx.function_from_file(:defp, :template_index, "templates/index.html.eex", [])
  EEx.function_from_file(:defp, :template_form, "templates/form.html.eex", [])

  alias Plug.Conn
  alias App.Models.Employee
  alias App.Utils.CSVGenerator

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

  @ok_resp 200
  @default_csv_name "employees.csv"

  def route("GET", [], conn) do
    conn
    |> Conn.put_resp_content_type("text/html")
    |> Conn.send_resp(@ok_resp, template_index())
  end

  def route("GET", ["employees"], conn) do
    conn
    |> Conn.put_resp_content_type("text/html")
    |> Conn.send_resp(@ok_resp, template_index())
  end

  def route("GET", ["employees_file"], conn) do
    case App.Repo.all(Employee) do
      nil ->
        conn
        |> Conn.send_resp(204, "No employees found")

      employees ->
        conn
        |> Conn.put_resp_content_type("text/csv")
        |> Conn.put_resp_header(
          "content-disposition",
          "attachment; filename=#{@default_csv_name}"
        )
        |> Conn.send_resp(200, CSVGenerator.generate_csv(employees))
    end
  end

  def route("GET", ["payment"], conn) do
    conn
    |> Conn.put_resp_content_type("text/html")
    |> Conn.send_resp(@ok_resp, template_form())
  end

  def route(_method, _path, conn) do
    conn
    |> Conn.send_resp(404, "Couldn't find that page, sorry!!")
  end
end