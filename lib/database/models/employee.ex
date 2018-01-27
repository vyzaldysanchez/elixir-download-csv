defmodule App.Models.Employee do
  use Ecto.Schema

  @derive {Poison.Encoder,
           only: [
             :first_name,
             :last_name,
             :email,
             :charter,
             :bank_account,
             :payable_amount
           ]}

  schema "employees" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:charter, :string)
    field(:bank_account, :string)
    field(:payable_amount, :decimal, precision: 5)

    timestamps()
  end
end
