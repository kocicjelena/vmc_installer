CF 1.0.0 with Ruby 1.9.3
==========================

Getting Started
  login [EMAIL] Authenticate with the target
  info          Display information on the current target, user, etc.
  logout        Log out from the target
  target [URL]  Set or display the target cloud, organization, and space

Applications
  app [APP]     Show app information
  apps          List your applications

  Management
    delete APPS...      Delete an application
    start APPS...       Start an application
    restart APPS...     Stop and start an application
    push [NAME]         Push an application, syncing changes if it exists
    stop APPS...        Stop an application
    console APP         Open a console connected to your app

Services
  services              List your services
  service SERVICE       Show service information

  Management
    bind-service [SERVICE] [APP]        Bind a service to an application
    unbind-service [SERVICE] [APP]      Unbind a service from an application
    create-service [OFFERING] [NAME]    Create a service
    delete-service [SERVICE]            Delete a service
    tunnel [INSTANCE] [CLIENT]          Create a local tunnel to a service.

Organizations
  create-org [NAME]             Create an organization
  delete-org [ORGANIZATION]     Delete an organization
  org [ORGANIZATION]            Show organization information
  orgs                          List available organizations

Spaces
  create-space [NAME] [ORGANIZATION]    Create a space in an organization
  delete-space SPACE                    Delete a space and its contents
  spaces [ORGANIZATION]                 List spaces in an organization
  space [SPACE]                         Show space information

Routes
  delete-route ROUTE    Delete a route
  routes                List routes in a space

Domains
  unmap-domain DOMAIN   Unmap a domain from an organization or space
  map-domain NAME       Map a domain to an organization or space
  domains [SPACE]       List domains in a space

Options:
      --[no-]color                 Use colorful output
      --[no-]script                Shortcut for --quiet and --force
      --debug                      Print full stack trace (instead of crash log)
      --http-proxy HTTP_PROXY      Connect though an http proxy server
      --https-proxy HTTPS_PROXY    Connect though an https proxy server
  -V, --verbose                    Print extra information
  -f, --[no-]force                 Skip interaction when possible
  -h, --help                       Show command usage
  -m, --manifest FILE              Path to manifest file to use
  -q, --[no-]quiet                 Simplify output format
  -t, --trace                      Show API traffic
  -v, --version                    Print version number
