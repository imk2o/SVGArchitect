
function isClickableElement(element) {
    var clickable_elements = {
        rect: true,
        circle: true,
        text: true,
        path: true,
        image: true
    };

    return (clickable_elements[element.tagName]) ? true : false;
}

function hasChildElement(element) {
    if (element.children) {
        return element.children.length !== 0;
    } else {
        for (var child = element.firstChild; child; child = child.nextSibling) {
            if (child.nodeType == 1) {
                return true;
            }
        }
    }
    return false;
}

function createElementNode(parent, element, option) {
    if (typeof element === 'function') {
        element = element(parent.data.element);
    }

    var has_child_element = hasChildElement(element);
    var node = parent.addChild({
        title: element.tagName,
        tooltip: element.innerText,
        isFolder: has_child_element,//option.folder,
        isLazy: has_child_element,
        element: element                    // 任意データ(node.data.xxx で参照可能)
    });

    //if (option.clickable) {
    if (isClickableElement(element)) {
        // 図形がクリックされたらノードをアクティベート
        $(element).click(function() { node.activate(); });
    }

    return node;
}

function rand(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randColor() {
    var r = rand(128, 255);
    var g = rand(128, 255);
    var b = rand(128, 255);
    return '#' + r.toString(16) + g.toString(16) + b.toString(16);
}

// 一意な ID を生成する
function createUniqueId(prefix) {
    var n = 1;
    do {
        var id = prefix + n
        n++;
        var l = $('#' + id).length;
    } while ($('#' + id).length);
    return id;
}

$(function(){    // body onload
    var svg = $('#svg').svg({settings: {
        xmlns: 'http://www.w3.org/2000/svg',
        'xmlns:xlink': 'http://www.w3.org/1999/xlink'
    }}).svg('get');

    $('#svg_tree').dynatree({
        selectMode: 1,    // Single selection
        clickFolderMode: 1,    // Activate (no expand)
        onLazyRead: function(node) {
            $(node.data.element).children().each(function() {
                createElementNode(node, this, {folder: false, clickable: true});
            });
        },
        onClick: function(node, event) {
            //alert("Clicked: " + node + " e: " + event);
        },
        onActivate: function(node) {
            //var inspector = 'inspector_' + node.data.element.tagName + '.html';
            //var inspector = 'inspector.html';
            //$('iframe').attr('src', inspector);
            var e_name = node.data.element.tagName
            var properties = inspector_specs[e_name] ? inspector_specs[e_name] : [];
            inspectCurrentElement(properties);
        }
    });
    // 最上位ノードを生成
    var root = $('#svg_tree').dynatree('getRoot');
    var top = createElementNode(root, svg.root(), {folder: true, clickable: false});
    top.activate();
    // defs ノードを生成
    var defs = createElementNode(top, function(parent) { return svg.defs(parent); }, {folder: true, clickable: false});

    // クリア
    $('#clear').click(function() {
        top.removeChildren();
        $(svg.root()).empty();
    });

    function parentNode() {
        var node = $('#svg_tree').dynatree('getActiveNode');
        if (['rect', 'circle', 'text', 'image'].indexOf(node.data.element.tagName) >= 0) {    // TODO
            node = node.parent;
        }
        return node;
    }

    // ツリーを再構築する
    function rebuildTree() {
        top.removeChildren();
        $(svg.root()).children().each(function() {
            createElementNode(top, this);
        });
        top.expand();
    }

    // 矩形の追加
    $('#add_rect').click(function() {
        var parent_node = parentNode();
        var node = createElementNode(parent_node, function(parent) {
            var x = rand(10, 300);
            var y = rand(10, 300);
            var width = rand(10, 100);
            var height = rand(10, 100);
            var fill = randColor();
            var stroke = randColor();
            var stroke_width = rand(1, 5);
            return svg.rect(parent, x, y, width, height, {
                fill: fill,
                stroke: stroke,
                strokeWidth: stroke_width,
                opacity: 1.0
            });
        }, {folder: false, clickable: true});

        parent_node.expand();
        node.activate();
    });

    // 円の追加
    $('#add_circle').click(function() {
        var parent_node = parentNode();
        var node = createElementNode(parent_node, function(parent) {
            var x = rand(10, 300);
            var y = rand(10, 300);
            var r = rand(10, 100);
            var fill = randColor();
            var stroke = randColor();
            var stroke_width = rand(1, 5);
            return svg.circle(parent, x, y, r);
            /*
            return svg.circle(parent, x, y, r, {
                fill: fill,
                stroke: stroke,
                strokeWidth: stroke_width,
                opacity: 1.0});
                */
        }, {folder: false, clickable: true});

        parent_node.expand();
        node.activate();
    });

    // テキストの追加
    $('#add_text').click(function() {
        var parent_node = parentNode();
        var node = createElementNode(parent_node, function(parent) {
            var x = rand(10, 300);
            var y = rand(10, 300);
            var size = rand(10, 80);
            var str = 'Text';
            var fill = randColor();
            var stroke = randColor();
            var stroke_width = rand(0, 3);
            return svg.text(parent, x, y, str, {
                fontSize: size,
                fill: fill,
                stroke: stroke,
                strokeWidth: stroke_width,
                opacity: 1.0
            });
        }, {folder: false, clickable: true});

        parent_node.expand();
        node.activate();
    });

    // 画像の追加
    $('#add_image').change(function(e) {
        var reader = new FileReader();
        reader.onload = function(f) {
            var parent_node = parentNode();
            var node = createElementNode(parent_node, function(parent) {
                var x = rand(10, 300);
                var y = rand(10, 300);
                var width = rand(10, 100);
                var height = rand(10, 100);
                var url = f.target.result;
                return svg.image(parent, x, y, width, height, url, {
                    opacity: 1.0
                });
            }, {folder: false, clickable: true});

            parent_node.expand();
            node.activate();
        };
        reader.readAsDataURL(e.target.files[0]);
    });

    // グループの追加
    $('#add_group').click(function() {
        var parent_node = parentNode();
        var node = createElementNode(parent_node, function(parent) {
            var id = createUniqueId('group');
            var fill = randColor();
            var stroke = randColor();
            var stroke_width = rand(1, 5);
            return svg.group(parent, id, {
                fill: fill,
                stroke: stroke,
                strokeWidth: stroke_width,
                opacity: 1.0
            });
        }, {folder: true, clickable: false});

        parent_node.expand();
        node.activate();
    });

    // グラデーション(linear)の追加
    $('#add_linear_gradient').click(function() {
        var parent_node = defs;//parentNode();
        var node = createElementNode(parent_node, function(parent) {
            var id = createUniqueId('grad');
            var start_color = randColor();
            var end_color = randColor();
            return svg.linearGradient(parent, id, [[0.0, start_color, 1.0], [1.0, end_color, 1.0]], {gradientUnits: 'objectBoundingBox'});
        }, {folder: true, clickable: false});

        parent_node.expand();
        node.activate();
    });

    // グラデーション(radial)の追加
    $('#add_radial_gradient').click(function() {
        var parent_node = defs;//parentNode();
        var node = createElementNode(parent_node, function(parent) {
            var id = createUniqueId('grad');
            var start_color = randColor();
            var end_color = randColor();
            return svg.radialGradient(parent, id, [[0.0, start_color, 1.0], [1.0, end_color, 1.0]], {gradientUnits: 'objectBoundingBox'});
        }, {folder: true, clickable: false});

        parent_node.expand();
        node.activate();
    });

    // アップロード
    $('#upload').change(function(e) {
        var reader = new FileReader();
        reader.onload = function(f) {
            // NOTE: svg タグに属性 xmlns="http://www.w3.org/2000/svg" が記述されていないと
            // 正しく表示されないので注意！
            svg.load(reader.result);
            rebuildTree();
        };
        reader.readAsText(e.target.files[0]);
    });

    // ダウンロード(TODO: Chrome 以外も動作確認)
    $('#download').click(function() {
        var serializer = new XMLSerializer();
        var data = serializer.serializeToString(svg.root());
        var blob = new Blob(
            [data],
            //{ type: 'image/svg+xml' }
            { type: 'application/octet-stream' }
        );
        var url = URL.createObjectURL(blob);
        location.href = url;
    });

    // Debug
    $('#debug').click(function() {
        /*
        //var xml = $.parseXML('<svg width="400px" height="300px"></svg>');
        var xml = $.parseXML('<svg></svg>');
        var e = xml.documentElement;
        e.width = 400;
        e.height = 300;
        $('#svg').append(e);
        */
    });
});
