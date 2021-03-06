defmodule Tweb.Application do
  use Application
  use Task, restart: :permanent

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Tweb.Repo, []),
      # Start the endpoint when the application starts
      supervisor(TwebWeb.Endpoint, []),
      # Start your own worker by calling: Tweb.Worker.start_link(arg1, arg2, arg3)
      # worker(Tweb.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tweb.Supervisor]
    Supervisor.start_link(children, opts)

    # start broadcasting tweets to the tweets:messages topic
    Task.async(TwebWeb.Twelastic.broadcast_tweets)
    ExRated.start_link([])
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
