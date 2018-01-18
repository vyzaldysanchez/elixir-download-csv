defmodule App.Utils.CSVGenerator do
    alias App.Models.Employee

    @internal_keys [:__meta__, :__struct__, :id, :inserted_at, :updated_at]

    def generate_csv(employees) do
        content = employees
        |> Enum.map(fn empl ->
            Map.drop(empl, @internal_keys)
            |> parse_employee_payment
            |> Map.values
        end)

        get_header_for(employees) ++ content
        |> CSV.encode
        |>Enum.to_list
        |>to_string
    end

    defp parse_employee_payment(employee) do
        Map.new(employee)
        |> Map.put(:payable_amount, Decimal.to_string(employee.payable_amount))
        |> Map.put(:description, "PAYMENT")
    end

    defp get_header_for(employees) do
        [
            ["NE20180118", "8748484883438", "888444548484",
                get_total_payment(employees), get_current_date()],
            get_csv_keys()
        ]
    end

    defp get_total_payment(employees) do
        App.Repo.aggregate(Employee, :sum, :payable_amount)
        |> to_string
    end

    defp get_current_date() do
        date = Date.utc_today

        [date.day, date.month, date.year]
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.pad_leading(&1, 2, "0"))
        |> Enum.join("-")
    end

    defp get_csv_keys do
        Map.drop(%Employee{}, @internal_keys)
        |> Map.put(:description, "PAYMENT")
        |> Map.keys
        |> Enum.map(&Atom.to_string(&1))
    end
end