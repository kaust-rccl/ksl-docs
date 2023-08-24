# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'KAUST Supercomputing Lab Support Documentation'
copyright = '2023, KSL'
author = 'Mohsin Ahmed Shaikh'

release = '0.1'
version = '0.1.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
    'sphinxcontrib.googleanalytics',
]

intersphinx_mapping = {
    'python': ('https://docs.python.org/3/', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}
intersphinx_disabled_domains = ['std']

templates_path = ['_templates']

# -- Options for HTML output

html_theme = 'piccolo_theme'
html_logo = './static/KAUST_logo.png'
html_theme_options = {
    "source_url": 'https://github.com/mshaikh786/ksl-docs/',
    "source_icon": "github",
    "banner_text": 'Checkout, <a href="https://mynewsletter.com/"> Tip of the Week</a>!',
    "show_theme_credit": False
    
}
# -- Options for EPUB output
epub_show_urls = 'footnote'
# configuration for the ``highlight_language``
highlight_language = 'bash'
highlight_options = {'stripall': True}


googleanalytics_id = 'G-4YML7KSJ4F'
googleanalytics_enabled=True
