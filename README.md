# secp

## Description
An utility to access EO data from multiple repositories

secp is a generic utility written in Bash to perform URL downloads to a sink directory.

The supported url schemes are ftp, scp, http, https, gridftp, file and nfs, with the possibility to perform authentication using basic FTP/HTTP authentication or more advanced SSO authentication schemas.

The application analyses HTML pages to follow links and redirects, parses RDF and ATOM feeds, supports downloads of URL lists, automatically decompresses files and directories and many other feature.

Tool works on a generic Linux distribution or on Windows (for windows, you need to install "Git for Windows" or the "Windows 10 Bash")

## Features

* Support for download from most of the ESA data archives and catalogues (SciHub, SMOS, VA4, ESAR, MERCI, etc...)
* Parallel downloads (optionally with multiple credentials)
* Support for ftp, scp, http, https, gridftp, hadoopfs, file and nfs.
* Support for HTTP/FTP basic auth (e.g. SciHub), ESA's EO-SSO, EO Data Gateway authentication
* Built-in credentials and session manager
* Automatic unpackaging of files
* Support for file lists in metalink, ATOM (@rel=enclosure), RDF, HTML (meta-refresh and href-tags), UAR (url textual file lists)

## Installation

Download the [secp](https://github.com/spinto/secp/raw/master/secp) script, and run it. In summary:
```shell
curl https://github.com/spinto/secp/raw/master/secp -o secp
chmod +x secp
./secp
```

NOTE: If you have a very minimal OS, you may need to install the following dependencies: curl, scp, gawk, sed, bash, sha256sum, file

## Basice usage
For a basic usage, you can just run
```shell
./secp <url>
```
Where <url> is the URL of the file you want to download.
Some more complicated examples are:
* Download the last 5 products from SciHub (with two parallel downloads)
```shell
./secp -J -co outdir -P 2 -F 'https://scihub.copernicus.eu/dhus/search?q=*&rows=5&start=0'
```
* Download the SMOS L2 products from 2016-09-01 to 2016-09-30
```shell
./secp -U -F 'https://smos-diss.eo.esa.int/socat/NRT_Open/search|service=SimpleOnlineCatalogue&version=1.0&request=search&format=text%2Fplain&pageCount=50&query.beginAcquisition.start=2016-09-01&query.beginAcquisition.stop=2016-09-30&query.productType=MIR_SMNRT2'
```     
## Advanced Usage
```shell
[spinto@demo] ./secp -h
Usage:
secp  [options] <url1> [<url2> ... <urlN>]

URL Parameters:
      Arguments are URL strings provided. If a parameter is specified as '-', URLs are read
      from standard input
 
Options:
      -h               displays this help page
      -a               abort on first error without attempting to process further URLs
      -q               quiet mode, local filenames are not echoed to stdout after transfer
      -f               force transfer of a physical copy of the file in case of nfs URLs
      -F <url-list>    get URLs from a file. It can be a <url-list> file, a metalink file or an
                       ATOM file.
      -d <driver-file> get additional drivers from shell file <driver-file>. Drivers shall contain
                       a named <protocol>Driver
      -o|O <out-dir>   defines the output directory for transfers (default is $PWD)
                       with -O the sink files or directories possibly existing in the output
                       directory will be overwritten.
      -s               skip download if sink path already exists
      -J               enable remote file name generation. If enabled, the driver will create the
                       output file name, which may be different from the one specified in the URL
      -c|-co <out-dir> creates the output directory if it does not exist. (you can use -co to
                       specify directly the output dir)
      -p <prefix>      prepend the given prefix to all output names
      -z               provide output as a compressed package (.gz for files or .tgz for folders).
                       NOTE: that it will not compress already compressed files (.gz, .tgz or .zip)
      -U|--no-uzip     disable file automatic decompression of .gz, .tgz and .zip files.
      -r <num-retries> defines the maximum number of retries (default is 5)
      -rt <seconds>    define the time (in seconds) between retries (default is 60)
      -t <timeout>     defines the timer (in seconds) for the watchdog timeout applicable to
                       gridftp, scp, ftp, http, and https schemes (default is 600 seconds)
      -R               do not retry transfer after timeout
      -H               do not follow file lists URLs. NOTE: By deafult, if a URL points to a metalink,
                       uar, html and rdf, these are decoded and all the linked data is downloaded.
      -w <tmpdir>      set up temporary directory for drivers (default to /tmp)
      -x <pattern>     exclude the files matching the pattern for directory input or file lists
      -K               private mode, disable storing of authentication session in ~/.secp_sess file
                       and passwords in the ~/.secp_cred file.
      -C <user>:<pass> force <user> and <pass> authentication (NOTE: these passwords will be stored
                       in clear text in the ~/.secp_cred file. Use the -K flag if you want to avoid
                       this behaviour. NOTE: If username/passowrd is specified it has precedence over
                       the certificate/proxy authentication)
      -X <crt>[:<key>] force usage of X509 authentication. If <key> is supplied, <crt> and <key> are
                       respectively the private and public proxy certificates. If <key> is not supplied,
                       <crt> is an X509 proxy certificate. (NOTE: the <crt> and <key> will be stored
                       in the ~/.secp_cred file. Use the -K flag if you want to avoid this behaviour.)
      -P <num-worker>  enable parallel download with the <num-worker> number of workers. If download
                       requires username/password, you need to specify it within the command line,
                       include it into the ~/.secp_cred file or use the -PC option.
      -PC <cred-file>  enable parallel download with multiple different credentials. One worker will be
                       spawn for each line of the credential file. The credential file shall contain
                       username/password couples in <user>:<pass> format.

Notes:
 *  Unless the quiet option is used (-q), the local path of each file (or directory) downloaded after each
    URL transfer is echoed, one per line
 *  Unless the -U option is used, if the output file is a .gz or .tgz file it will be decompressed
 *  Unless the -H options is specified, the software will follow Metalink, ATOM, RDF, HTML (href) and uar
    pages. the software will also follow HTTP meta-refresh and XML Retry-After tags
 *  The software will perform authentication if credentials are specified. Supported authentication types
    are 'basic', X509, EO-SSO and EO Data gateway. Credentials are stored in the ~/.secp_cred file, session
    cookies are stored in the ~/.secp_sess file (use -K switch to disable this behaviour)
 *  If the url is an HTTP url, everyhting after the special '|' caracter will be sent via an HTTP POST

Advanced usage examples:
  * Download the last 5 products from SciHub (with two parallel downloads)
     ./secp -J -co outdir -P 2 -F 'https://scihub.copernicus.eu/dhus/search?q=*&rows=5&start=0'
  * Download the SMOS L2 products from 2016-09-01 to 2016-09-30
     ./secp -U -F 'https://smos-diss.eo.esa.int/socat/NRT_Open/search|service=SimpleOnlineCatalogue&version=1.0&request=search&format=text%2Fplain&pageCount=50&query.beginAcquisition.start=2016-09-01&query.beginAcquisition.stop=2016-09-30&query.productType=MIR_SMNRT2'

Exit codes:
      0      all URLs were successfully downloaded
      1      an error occured during processing
      255    environment is invalid (e.g. invalid working directory) or invalid options are provided
      254    output directory does not exist or failed creating it (with -c option)

      if the -a option is used, the exit code is set to the error code of the last URL transfer:
      252    no driver available for URL
      251    an existing file or directory conflicts with the sink for the URL in the output directory
      250    an error occured while unpacking the output file or when packaging/compressing the output
             file (when -z or -Z option is used)
      128    a timeout occured while fetching an url
      127    a fatal error occured, source of error is not known or not handled by driver
      <128   error codes specific to the transfer scheme
      1      resource pointed by input URL do not exist
```
## Docker
secp can be executed also as a docker container. To download a file using a docker container, you can run
```shell
sudo docker run --rm -v $PWD:/data spinto/secp http://www.google.com/index.html -H -O /data
```
