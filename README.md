# ExfileMemory

[![Build Status](https://travis-ci.org/keichan34/exfile-memory.svg?branch=master)](https://travis-ci.org/keichan34/exfile-memory)

An in-memory (ets) storage adapter for [Exfile](https://github.com/keichan34/exfile).
Usually doesn't make much sense except for an ephemeral cache because it will be
completely emptied if your app restarts. Also, not shared between nodes.

## Installation

  1. Add exfile_memory to your list of dependencies in `mix.exs`:

        def deps do
          [
            {:exfile, "~> 0.1.0"},
            {:exfile_memory, "~> 0.0.1"}
          ]
        end

  2. Ensure exfile_memory is started before your application:

        def application do
          [
            applications: [
              :exfile,
              :exfile_memory
            ]
          ]
        end

  3. Configure the backend in `config.exs` (or environment equivalent)

        config :exfile, Exfile,
          backends: %{
            "cache" => [ExfileMemory.Backend, %{
              directory: "/",
              max_size: nil,
              hasher: Exfile.Hasher.Random
            }]
          }
