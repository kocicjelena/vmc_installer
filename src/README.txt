# VMC 0.5.0

The VMware Cloud CLI. This is the command line interface to VMware's Application Platform.

## Command Line Optoins

Showing basic command set. Run with 'help --all' to list all commands.

    Getting Started
      info         	Display information on the current target, user, etc.
      login [EMAIL]	Authenticate with the target
      logout       	Log out from the target
      target [URL] 	Set or display the target cloud, organization, and space
    
    Applications
      app [APP]	Show app information
      apps     	List your applications
    
      Management
        delete APPS... 	Delete an application
        push [NAME]    	Push an application, syncing changes if it exists
        restart APPS...	Stop and start an application
        start APPS...  	Start an application
        stop APPS...   	Stop an application
    
    Services
      service SERVICE	Show service information
      services       	List your service
    
      Management
        bind-service [SERVICE] [APP]    	Bind a service to an application
        create-service [OFFERING] [NAME]	Create a service
        delete-service [SERVICE]        	Delete a service
        unbind-service [SERVICE] [APP]  	Unbind a service from an application
        tunnel [INSTANCE] [CLIENT]      	Create a local tunnel to a service.
    
    Organizations
      create-org [NAME]        	Create an organization
      delete-org [ORGANIZATION]	Delete an organization
      org [ORGANIZATION]       	Show organization information
      orgs                     	List available organizations
    
    Spaces
      create-space [NAME] [ORGANIZATION]	Create a space in an organization
      delete-space SPACES...            	Delete a space and its contents
      space [SPACE]                     	Show space information
      spaces [ORGANIZATION]             	List spaces in an organization
    
    Routes
      routes	List routes in a space
    
    Domains
      domains [SPACE]    	List domains in a space
      map-domain NAME    	Map a domain to an organization or space
      unmap-domain DOMAIN	Unmap a domain from an organization or space
    
    Options:
          --[no-]color       Use colorful output
          --[no-]script      Shortcut for --quiet and --force
          --debug            Print full stack trace (instead of crash log)
      -V, --verbose          Print extra information
      -f, --[no-]force       Skip interaction when possible
      -h, --help             Show command usage
      -m, --manifest FILE    Path to manifest file to use
      -q, --[no-]quiet       Simplify output format
      -t, --trace            Show API traffic
      -u, --proxy EMAIL      Run this command as another user (admin)
      -v, --version          Print version number


## Simple Story (for Ruby apps)

    vmc target api.cloudfoundry.com
    vmc login
    bundle package
    vmc push
