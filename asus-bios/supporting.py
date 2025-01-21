# libraries
from fake_useragent import UserAgent
import requests
from lxml import etree
from bs4 import BeautifulSoup

# constants
URL = "https://www.asus.com/laptops/for-gaming/tuf-gaming/asus-tuf-gaming-a15-2023/helpdesk_bios/?model2Name=FA507NU"


# modules
def get_latest_bios_verion() -> None:
    with requests.Session() as s:
        r = s.get(url=URL, headers={'User-Agent': UserAgent().random})
        if r.status_code == 200:
            dom = etree.HTML(str(BeautifulSoup(r.text, features="lxml")))

            nodes_div_version_info = dom.xpath("//div[text()='BIOS for ASUS EZ Flash Utility']")[0]\
                    .xpath("./following-sibling::div/child::div")
            node_a_href = dom.xpath("//div[text()='BIOS for ASUS EZ Flash Utility']")[0]\
                    .xpath("./parent::div/following-sibling::div/child::a")[0]

            info = {
                "version": nodes_div_version_info[0].text.strip().replace("Version ", ""),
                "size": nodes_div_version_info[1].text.strip(),
                "date": nodes_div_version_info[2].text.strip(),
                "href": node_a_href.get("href")
            }
            print(f"{info['version']}\n{info['href']}")
        else:
            print("error\n")

# main
get_latest_bios_verion()
