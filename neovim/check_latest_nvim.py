import requests
from lxml import etree
from bs4 import BeautifulSoup
from fake_useragent import UserAgent

url = "https://github.com/neovim/neovim/releases"
with requests.Session() as s:
    r = s.get(url, headers={'User-Agent': UserAgent().random})
    if r.status_code == 200:
        dom = etree.HTML(str(BeautifulSoup(r.text, features='lxml')))
        node_a = dom.xpath("//span[text()='Latest']/parent::a/parent::span/preceding-sibling::span/child::a")
        if node_a:
            print(node_a[0].text)
        else:
            raise Exception("No node found! \nPlease check the xpath expression again")

    else:
        raise Exception(f"Failed fetching: error code {r.status_code}")
