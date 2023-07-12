<!-- RUBIKRECON -->
<p align="center">
  <a href="https://ibb.co/xsBKq9S"><img src="https://github.com/rubikproxy/rubikrecon/assets/84948167/dde82c9e-4583-468d-b899-d627bccf40c9" alt="RUBIKRECON Banner"></a>
</p>
<h1 align="center"><b>RUBIKRECON - Bug Bounty and Reconnaissance Tool</b></h1>
<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Author-rubikproxy-blue?style=flat-square">
  <img src="https://img.shields.io/badge/Open%20Source-Yes-darkgreen?style=flat-square">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-lightblue?style=flat-square">
  <img src="https://img.shields.io/badge/Written%20In-Bash-darkcyan?style=flat-square">
</p>
<p align="center"><b>RUBIKRECON</b> is a powerful Bug Bounty and Reconnaissance tool designed to automate various tasks involved in the reconnaissance phase of security testing and bug bounty hunting.</p>

## Features

- Subdomain Enumeration
- DNS Enumeration
- IP Reputation Check
- Technology Stack Identification
- Port Scanning with Service Detection
- HTTP Security Headers Analysis
- Robots.txt Analysis
- Whois Information Retrieval
- Firewall Detection
- Additional Information Gathering

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/rubikproxy/rubikrecon.git
   ```

2. Change into the project directory:

   ```bash
   cd rubikrecon
   ```

3. Install the required dependencies:

   ```bash
   bash install.sh
   ```

## Usage

```bash
bash rubikrecon.sh -t <target> -o <output_filename>
```

- `-t <target>`: Specify the target domain or IP address to perform reconnaissance on.
- `-o <output_filename>`: Specify the desired name for the output HTML report.

## Examples

```bash
# Perform reconnaissance on example.com and generate the output report as example_report.html
bash rubikrecon.sh -t example.com -o example_report.html
```

## HTML Report

The tool generates a comprehensive HTML report with detailed information gathered during the reconnaissance process. The report includes:

- Summary of the reconnaissance process
- Target Information (IP address, WHOIS data, HTTP headers)
- Subdomain enumeration results
- DNS enumeration results
- IP reputation check results
- Port scanning and service detection results
- HTTP security headers analysis results
- Robots.txt analysis results
- Firewall detection results
- Additional information gathered about the target

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

---

**RUBIKRECON - Bug Bounty and Reconnaissance Tool**

Created by [rubikproxy](https://github.com/rubikproxy)

Twitter: [@rubikproxy](https://twitter.com/rubikproxy)
