#!/bin/bash

# Check if the required tools are installed
declare -a required_tools=("subfinder" "naabu" "httpx" "nmap" "aquatone" "gau" "waybackurls" "arjun" "curl" "host" "dig")
missing_tools=()

for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        missing_tools+=("$tool")
    fi
done

# Install missing tools
if [[ ${#missing_tools[@]} -gt 0 ]]; then
    echo "Installing missing tools: ${missing_tools[*]}"
    for tool in "${missing_tools[@]}"; do
        echo "Installing $tool..."
        if [[ $tool == "aquatone" ]]; then
            go get -u github.com/michenriksen/aquatone >/dev/null 2>&1
        elif [[ $tool == "gau" ]]; then
            go get -u github.com/lc/gau >/dev/null 2>&1
        elif [[ $tool == "waybackurls" ]]; then
            go get -u github.com/tomnomnom/waybackurls >/dev/null 2>&1
        elif [[ $tool == "arjun" ]]; then
            go get -u github.com/s0md3v/Arjun >/dev/null 2>&1
        elif [[ $tool == "curl"]]; then
            sudo apt-get install curl >/dev/null 2>&1
        elif [[ $tool == "host"]]; then
            sudo apt-get install host >/dev/null 2>
        elif [[ $tool == "dig"]]; then
            sudo apt-get install digest >/dev/null 2>
        else
            go get -u "$tool" >/dev/null 2>&1
        fi
    done
    echo "All missing tools installed successfully."
else
    echo "All required tools are already installed."
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${GREEN}
   ██████╗  ██████╗ ██████╗ ██╗   ██╗██╗     ███████╗
  ██╔════╝ ██╔════╝██╔═══██╗██║   ██║██║     ██╔════╝
  ██║  ███╗██║     ██║   ██║██║   ██║██║     ███████╗
  ██║   ██║██║     ██║   ██║██║   ██║██║     ╚════██║
  ╚██████╔╝╚██████╗╚██████╔╝╚██████╔╝███████╗███████║
   ╚═════╝  ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝

  RUBIKRECON - Bug Bounty and Reconnaissance Tool
                 Created by RubikProxy
${NC}"

# Read the target from the user
read -p "Enter the target domain: " target

# Get the target IP address
target_ip=$(dig +short "$target" | head -n 1)

# Get additional information about the target
hostname=$(host "$target" | grep 'pointer' | cut -d ' ' -f 5)
nameservers=$(dig +short NS "$target")
mx_records=$(dig +short MX "$target")
txt_records=$(dig +short TXT "$target")
spf_records=$(dig +short TXT "$target" | grep 'v=spf1')
cname_records=$(dig +short CNAME "$target")
whois_info=$(whois "$target")

# Create a timestamp for the report
timestamp=$(date +"%Y%m%d%H%M%S")

# Set the output filename
read -p "Enter the output filename (default: rubikrecon_report.html): " output_filename
output_filename=${output_filename:-rubikrecon_report.html}

# Create the HTML report
echo "<html>
<head>
    <title>RUBIKRECON - Bug Bounty and Reconnaissance Tool</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333333;
        }
        h1 {
            color: #333333;
            text-align: center;
            margin-top: 50px;
        }
        .section {
            background-color: #ffffff;
            padding: 20px;
            margin: 20px;
            border-radius: 5px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }
        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .section-content {
            margin-left: 20px;
        }
        .tool-name {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .tool-output {
            margin-left: 20px;
        }
        pre {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <h1>RUBIKRECON - Bug Bounty and Reconnaissance Tool</h1>
    <div class='section'>
        <div class='section-title'>Target Information</div>
        <div class='section-content'>
            <div class='tool-name'>Target Domain:</div>
            <div>$target</div>
            <div class='tool-name'>Target IP Address:</div>
            <div>$target_ip</div>
            <div class='tool-name'>Hostname:</div>
            <div>$hostname</div>
            <div class='tool-name'>Nameservers:</div>
            <div>$nameservers</div>
            <div class='tool-name'>MX Records:</div>
            <div>$mx_records</div>
            <div class='tool-name'>TXT Records:</div>
            <div>$txt_records</div>
            <div class='tool-name'>SPF Records:</div>
            <div>$spf_records</div>
            <div class='tool-name'>CNAME Records:</div>
            <div>$cname_records</div>
            <div class='tool-name'>Whois Information:</div>
            <pre>$whois_info</pre>
        </div>
    </div>" > "$output_filename"

# Firewall Detection
echo -e "${YELLOW}[*] Running Firewall Detection...${NC}"
echo "<div class='section'>
        <div class='section-title'>Firewall Detection</div>
        <div class='section-content'>
            <div class='tool-output'>" >> "$output_filename"
if [[ -n "$target_ip" ]]; then
    echo -e "${GREEN}[+] Firewall is not blocking the target IP address.${NC}"
    echo "<div class='tool-name'>Firewall Status:</div>
        <div class='tool-output'>Firewall is not blocking the target IP address.</div>" >> "$output_filename"
else
    echo -e "${RED}[-] Firewall is blocking the target IP address.${NC}"
    echo "<div class='tool-name'>Firewall Status:</div>
        <div class='tool-output'>Firewall is blocking the target IP address.</div>" >> "$output_filename"
fi
echo "</div>
    </div>" >> "$output_filename"

# DNS Enumeration
if command -v "subfinder" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running DNS Enumeration...${NC}"
    echo "<div class='section'>
            <div class='section-title'>DNS Enumeration (Subfinder)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    subfinder -d "$target" -silent >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# IP Reputation Check
if command -v "naabu" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running IP Reputation Check...${NC}"
    echo "<div class='section'>
            <div class='section-title'>IP Reputation Check (Naabu)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    naabu -host "$target" -silent -verify >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# Technology Stack Identification
if command -v "httpx" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running Technology Stack Identification...${NC}"
    echo "<div class='section'>
            <div class='section-title'>Technology Stack Identification (HTTPX)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    httpx -host "$target" -no-colors -silent -tech-detect >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# Port Scanning with Service Detection
if command -v "nmap" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running Port Scanning with Service Detection...${NC}"
    echo "<div class='section'>
            <div class='section-title'>Port Scanning with Service Detection (Nmap)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    nmap -sS "$target" >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# Robots.txt Analysis
if command -v "curl" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running Robots.txt Analysis...${NC}"
    echo "<div class='section'>
            <div class='section-title'>Robots.txt Analysis (Curl)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    curl -s "$target/robots.txt" >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# HTTP Security Headers Analysis
if command -v "curl" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running HTTP Security Headers Analysis...${NC}"
    echo "<div class='section'>
            <div class='section-title'>HTTP Security Headers Analysis (Curl)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    curl -I -s "$target" >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# DNS Zone Transfer
if command -v "dig" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running DNS Zone Transfer...${NC}"
    echo "<div class='section'>
            <div class='section-title'>DNS Zone Transfer (Dig)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    dig axfr "@$target" >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# HTTP Request Smuggling
if command -v "arjun" >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Running HTTP Request Smuggling...${NC}"
    echo "<div class='section'>
            <div class='section-title'>HTTP Request Smuggling (Arjun)</div>
            <div class='section-content'>
                <div class='tool-output'>" >> "$output_filename"
    arjun -u "$target" >> "$output_filename"
    echo "</div>
            </div>
        </div>" >> "$output_filename"
fi

# Footer
echo "<div class='footer'>
        <p>Created by <a href='https://twitter.com/rubikproxy'>@rubikproxy</a></p>
    </div>
</body>
</html>" >> "$output_filename"

echo -e "${GREEN}[*] Reconnaissance completed. HTML report generated: $output_filename${NC}"
