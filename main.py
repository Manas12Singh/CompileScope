from flask import Flask, render_template_string, request, redirect, url_for
import os
import json
import subprocess

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'temp'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>CompileScope</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .tabs { margin-bottom: 20px; }
        .tab { display: inline-block; margin-right: 10px; }
        .tab a { text-decoration: none; padding: 8px 16px; background: #eee; border-radius: 4px; color: #333; }
        .tab a.active { background: #4285f4; color: #fff; }
        pre { background: #f4f4f4; padding: 10px; border-radius: 4px; }
        .tree ul { list-style-type: none; }
        .tree li { margin-left: 20px; }
    </style>
</head>
<body>
    <h1>CompileScope</h1>
    <form method="post" action="/" enctype="multipart/form-data">
        <textarea name="code" rows="10" cols="80" placeholder="Enter your C code here...">{{ code|default('') }}</textarea><br>
        <button type="submit">Compile</button>
    </form>
    {% if compiled %}
    <div class="tabs">
        <div class="tab"><a href="{{ url_for('index', tab='tokens') }}" class="{{ 'active' if tab == 'tokens' else '' }}">Tokens</a></div>
        <div class="tab"><a href="{{ url_for('index', tab='ast') }}" class="{{ 'active' if tab == 'ast' else '' }}">AST</a></div>
        <div class="tab"><a href="{{ url_for('index', tab='asm') }}" class="{{ 'active' if tab == 'asm' else '' }}">ASM</a></div>
    </div>
    <div>
        {% if tab == 'tokens' %}
            <h2>Tokens</h2>
            <pre>{{ tokens }}</pre>
        {% elif tab == 'ast' %}
            <h2>AST</h2>
            <div class="tree">{{ ast_html|safe }}</div>
        {% elif tab == 'asm' %}
            <h2>ASM Code</h2>
            <pre>{{ asm }}</pre>
        {% endif %}
    </div>
    {% endif %}
</body>
</html>
'''

def render_tree(node):
    if isinstance(node, dict):
        label = node.get('type', 'Node')
        children = node.get('children', [])
        html = f"<li><strong>{label}</strong>"
        if children:
            html += "<ul>"
            for child in children:
                html += render_tree(child)
            html += "</ul>"
        html += "</li>"
        return html
    return ""

@app.route('/', methods=['GET', 'POST'])
def index():
    code = ''
    compiled = False
    tab = request.args.get('tab', 'tokens')
    tokens = ''
    ast_html = ''
    asm = ''
    if request.method == 'POST':
        code = request.form['code']
        temp_c_path = os.path.join(app.config['UPLOAD_FOLDER'], 'temp.c')
        with open(temp_c_path, 'w') as f:
            f.write(code)
        # Run the compiler
        try:
            subprocess.run(['./comp', '-S', temp_c_path], check=True)
        except Exception as e:
            tokens = f"Compilation error: {e}"
            compiled = True
            return render_template_string(TEMPLATE, code=code, compiled=compiled, tab=tab, tokens=tokens, ast_html=ast_html, asm=asm)
        compiled = True
        return redirect(url_for('index', tab='tokens'))
    if os.path.exists('tokens.txt'):
        with open('tokens.txt') as f:
            tokens = f.read()
    if os.path.exists('ast.json'):
        with open('ast.json') as f:
            try:
                ast_data = json.load(f)
                ast_html = "<ul>" + render_tree(ast_data) + "</ul>"
            except Exception:
                ast_html = "<pre>Invalid AST JSON</pre>"
    if os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], 'temp.s')):
        with open(os.path.join(app.config['UPLOAD_FOLDER'], 'temp.s')) as f:
            asm = f.read()
    return render_template_string(TEMPLATE, code=code, compiled=compiled, tab=tab, tokens=tokens, ast_html=ast_html, asm=asm)

if __name__ == '__main__':
    app.run(debug=True)