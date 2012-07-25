    function setpageval(pageid) {
        $.post('/index.cfm/pages/getpagedata',{pageID:pageid,returnformat:'JSON'},function(data) {
            $('iframe.wysihtml5-sandbox').each(function(i, el){
                el.contentWindow.document.body.innerHTML = el.contentWindow.document.body.innerHTML + data ;
            });
        });
        $("#Insert_page").dialog2("close");
    }

    function setval(filename,filesize,filepath) {
             $("#selectedfilelist").html("<span><b>Selected file:</b></span><br /><span>" + filename + "</span>(<span>" + formatFileSize(filesize) + "</span>)<span style='display:none;'>" + filepath + "</span>");
             $("#Insert_Image").dialog2("close");
        }

    function editimagebtn() {
        if ($("#bootstrap-wysihtml5-insert-image-url").val() == "") {
            if ($("#selectedfilelist").html() != "") {
                imagename = $("#selectedfilelist span").eq(1).html();
                var imagesize = $("#selectedfilelist span").eq(2).html();
                var imagepath = $("#selectedfilelist span").eq(3).html();
                 $("#image1").attr('src',imagepath + imagename);
                return launchEditor('image1', imagepath + imagename);
            }
        } else {
               imagename = $("#bootstrap-wysihtml5-insert-image-url").val();
               imagename = imagename.substr(imagename.lastIndexOf("/")+1,imagename.length);
                 $("#image1").attr('src',$("#bootstrap-wysihtml5-insert-image-url").val());
                return launchEditor('image1', $("#bootstrap-wysihtml5-insert-image-url").val());
            }
        return false;
   }
    function insertimagebtn(ev) {
        if ($("#bootstrap-wysihtml5-insert-image-url").val() == "") {
            if ($("#selectedfilelist").html() != "") {
                var imagename = $("#selectedfilelist span").eq(1).html() ;
                var imagesize = $("#selectedfilelist span").eq(2).html() ;
                var imagepath = $("#selectedfilelist span").eq(3).html() ;
                $("#bootstrap-wysihtml5-insert-image-url").val(imagepath + imagename);
            }
        } else {
            imagename = $("#bootstrap-wysihtml5-insert-image-url").val() ;
            imagename = imagename.substr(imagename.lastIndexOf("/")+1,imagename.length);
            $('#myModal').modal({
             keyboard: false,
             backdrop:'static'
            });
            $(".modal-backdrop").css('z-index','10000');
            $.post('/index.cfm/webfiles/insertlinktoimage',{newURLLink:$("#bootstrap-wysihtml5-insert-image-url").val(),OldName:imagename,returnformat:'JSON'},function(data) {
               $('iframe.wysihtml5-sandbox').each(function(i, el){
                    el.contentWindow.document.getElementById('Imageid').setAttribute('src',data) ;
                    el.contentWindow.document.getElementById('Imageid').removeAttribute('id') ;
                    $(".markItUp").html(el.contentWindow.document.body.innerHTML.replace(/%0D/g,"").replace(/%0A/g,"").replace(/%09/g,""));
                    el.contentWindow.document.body.innerHTML = $(".markItUp").html().replace(/&lt;/g,"<").replace(/&gt;/g,">");
                    $('#myModal').modal('hide');
                    $(".modal-backdrop").css('z-index','1040');
                });
            });
        }
    }
!function($, wysi) {
    "use strict";

    var templates = {
        "font-styles": "<li class='dropdown'>" +
                           "<a class='btn dropdown-toggle' data-toggle='dropdown' href='#'>" +
                               "<i class='icon-font'></i>&nbsp;<span class='current-font'>Normal text</span>&nbsp;<b class='caret'></b>" +
                           "</a>" +
                           "<ul class='dropdown-menu'>" +
                               "<li><a data-wysihtml5-command='formatBlock' data-wysihtml5-command-value='div'>Normal text</a></li>" +
                               "<li><a data-wysihtml5-command='formatBlock' data-wysihtml5-command-value='h1'>Heading 1</a></li>" +
                               "<li><a data-wysihtml5-command='formatBlock' data-wysihtml5-command-value='h2'>Heading 2</a></li>" +
                           "</ul>" +
                       "</li>",
        "emphasis":    "<li>" +
                           "<div class='btn-group'>" +
                               "<a class='btn' data-wysihtml5-command='bold' title='CTRL+B'>Bold</a>" +
                               "<a class='btn' data-wysihtml5-command='italic' title='CTRL+I'>Italic</a>" +
                               "<a class='btn' data-wysihtml5-command='underline' title='CTRL+U'>Underline</a>" +
                           "</div>" +
                       "</li>",
        "lists":       "<li>" +
                           "<div class='btn-group'>" +
                               "<a class='btn' data-wysihtml5-command='insertUnorderedList' title='Unordered List'><i class='icon-list'></i></a>" +
                               "<a class='btn' data-wysihtml5-command='insertOrderedList' title='Ordered List'><i class='icon-th-list'></i></a>" +
                               "<a class='btn' data-wysihtml5-command='Outdent' title='Outdent'><i class='icon-indent-right'></i></a>" +
                               "<a class='btn' data-wysihtml5-command='Indent' title='Indent'><i class='icon-indent-left'></i></a>" +
                           "</div>" +
                       "</li>",
        "link":        "<li>" +
                           "<div class='bootstrap-wysihtml5-insert-link-modal modal hide fade'>" +
                               "<div class='modal-header'>" +
                                   "<a class='close' data-dismiss='modal'>&times;</a>" +
                                   "<h3>Insert Link</h3>" +
                               "</div>" +
                               "<div class='modal-body'>" +
                                   "<input value='http://' class='bootstrap-wysihtml5-insert-link-url input-xlarge'>" +
                               "</div>" +
                               "<div class='modal-footer'>" +
                                   "<a href='#' class='btn' data-dismiss='modal'>Cancel</a>" +
                                   "<a href='#' class='btn btn-primary' data-dismiss='modal'>Insert link</a>" +
                               "</div>" +
                           "</div>" +
                           "<a class='btn' data-wysihtml5-command='createLink' title='Link'><i class='icon-share'></i></a>" +
                       "</li>",
        "image":       "<li>" +
                           "<div class='bootstrap-wysihtml5-insert-image-modal modal hide fade'>" +
                               "<div class='modal-header'>" +
                                   "<a class='close' data-dismiss='modal'>&times;</a>" +
                                   "<h3>Insert Image</h3>" +
                               "</div>" +
                               "<div class='modal-body'>" +
                                   "Choose between the following 2 options:<br />" +
                                   "1. Browse images or upload new image <br /><br />" +
                                   "&nbsp;&nbsp;&nbsp;<input value='Browse Images on Server' id='show-server-notice-link' class='btn  input-xlarge' type='button'>" +
                                   "<br /><br />" +
                                   "<div id='selectedfilelist'></div><br />" +
                                   "2. Type full URL of image (including http://) <br /><br />" +
                                   "&nbsp;&nbsp;&nbsp;<input class='bootstrap-wysihtml5-insert-image-url input-xlarge' type='text' id='bootstrap-wysihtml5-insert-image-url'>" +
                                    "<img src='' id='image1' style='display:none;'/>" +
                               "</div>" +
                               "<div class='modal-footer'>" +
                                   "<a href='#' class='btn editimagebtn' onclick='return editimagebtn();'>Edit Image</a>" +
                                   "<a href='#' class='btn btn-primary insertimagebtn' data-dismiss='modal' onclick='insertimagebtn(event);'>Save & Insert Image</a>" +
                                   "<a href='#' class='btn ' data-dismiss='modal'>Cancel & close this window</a>" +
                               "</div>" +
                           "</div>" +
                           "<a class='btn' data-wysihtml5-command='insertImage' title='Insert image'><i class='icon-picture'></i></a>" +
                       "</li>",
        "page":       "<li>" +
                           "<div class='bootstrap-wysihtml5-insert-page-modal modal hide fade'>" +
                               "<div class='modal-header'>" +
                                   "<a class='close' data-dismiss='modal'>&times;</a>" +
                                   "<h3>Insert Page</h3>" +
                               "</div>" +
                               "<div class='modal-body'>" +
                               "</div>" +
                               "<div class='modal-footer'>" +
                                   "<a href='#' class='btn ' data-dismiss='modal'>Cancel & close this window</a>" +
                               "</div>" +
                           "</div>" +
                           "<a class='btn' data-wysihtml5-command='insertPage' id='show-server-page-link' title='Insert page'><i class='icon-plus-sign'></i></a>" +
                       "</li>",

        "html":
                       "<li>" +
                           "<div class='btn-group'>" +
                               "<a class='btn' data-wysihtml5-action='change_view' title='Edit HTML'><i class='icon-pencil'></i></a>" +
                           "</div>" +
                       "</li>"
    };

    var defaultOptions = {
        "font-styles": true,
        "emphasis": true,
        "lists": true,
        "html": false,
        "link": true,
        "image": true,
        "page": true,
        events: {},
        parserRules: {
            tags: {
                "b":  {},
                "i":  {},
                "br": {},
                "ol": {},
                "ul": {},
                "li": {},
                "h1": {},
                "h2": {},
                "blockquote": {},
                "u": 1,
                "img": {
                    "check_attributes": {
                        "width": "numbers",
                        "alt": "alt",
                        "src": "url",
                        "height": "numbers"
                    }
                },
                "a":  {
                    set_attributes: {
                        target: "_blank",
                        rel:    "nofollow"
                    },
                    check_attributes: {
                        href:   "url" // important to avoid XSS
                    }
                }
            }
        },
        stylesheets: []
    };

    var Wysihtml5 = function(el, options) {
        this.el = el;
        this.toolbar = this.createToolbar(el, options || defaultOptions);
        this.editor =  this.createEditor(options);

        window.editor = this.editor;

        $('iframe.wysihtml5-sandbox').each(function(i, el){
            $(el.contentWindow).off('focus.wysihtml5').on({
              'focus.wysihtml5' : function(){
                 $('li.dropdown').removeClass('open');
               }
            });
        });
    };
    Wysihtml5.prototype = {

        constructor: Wysihtml5,

        createEditor: function(options) {
            options = $.extend(defaultOptions, options || {});
		    options.toolbar = this.toolbar[0];

		    var editor = new wysi.Editor(this.el[0], options);

            if(options && options.events) {
                for(var eventName in options.events) {
                    editor.on(eventName, options.events[eventName]);
                }
            }

            return editor;
        },

        createToolbar: function(el, options) {
            var self = this;
            var toolbar = $("<ul/>", {
                'class' : "wysihtml5-toolbar",
                'style': "display:none"
            });

            for(var key in defaultOptions) {
                var value = false;

                if(options[key] !== undefined) {
                    if(options[key] === true) {
                        value = true;
                    }
                } else {
                    value = defaultOptions[key];
                }

                if(value === true) {
                    toolbar.append(templates[key]);

                    if(key == "html") {
                        this.initHtml(toolbar);
                    }

                    if(key == "link") {
                        this.initInsertLink(toolbar);
                    }

                    if(key == "image") {
                        this.initInsertImage(toolbar);
                    }

                }
            }

            toolbar.find("a[data-wysihtml5-command='formatBlock']").click(function(e) {
                var el = $(e.srcElement);
                self.toolbar.find('.current-font').text(el.html());
            });

            this.el.before(toolbar);

            return toolbar;
        },

        initHtml: function(toolbar) {
            var changeViewSelector = "a[data-wysihtml5-action='change_view']";
            toolbar.find(changeViewSelector).click(function(e) {
                toolbar.find('a.btn').not(changeViewSelector).toggleClass('disabled');
            });
        },

           initInsertImage: function(toolbar) {
            var self = this;
            var insertImageModal = toolbar.find('.bootstrap-wysihtml5-insert-image-modal');
            var urlInput = insertImageModal.find('.bootstrap-wysihtml5-insert-image-url');
            var insertButton = insertImageModal.find('a.btn-primary');
            var initialValue = urlInput.val();
            var insertImage = function() {
                var url = urlInput.val();
                urlInput.val(initialValue);
                self.editor.composer.commands.exec("insertImage", url);
            };

            urlInput.keypress(function(e) {
                if(e.which == 13) {
                    insertImage();
                    insertImageModal.modal('hide');
                }
            });

            insertButton.click(insertImage);

            insertImageModal.on('shown', function() {
                urlInput.focus();
            });

            insertImageModal.on('hide', function() {
                self.editor.currentView.element.focus();
            });

            toolbar.find('a[data-wysihtml5-command=insertImage]').click(function() {
                insertImageModal.modal('show');
                insertImageModal.on('click.dismiss.modal', '[data-dismiss="modal"]', function(e) {
					e.stopPropagation();
				});
                return false;
            });
        },

        initInsertLink: function(toolbar) {
            var self = this;
            var insertLinkModal = toolbar.find('.bootstrap-wysihtml5-insert-link-modal');
            var urlInput = insertLinkModal.find('.bootstrap-wysihtml5-insert-link-url');
            var insertButton = insertLinkModal.find('a.btn-primary');
            var initialValue = urlInput.val();

            var insertLink = function() {
                var url = urlInput.val();
                urlInput.val(initialValue);
                self.editor.composer.commands.exec("createLink", {
                    href: url,
                    target: "_blank",
                    rel: "nofollow"
                });
            };
            var pressedEnter = false;

            urlInput.keypress(function(e) {
                if(e.which == 13) {
                    insertLink();
                    insertLinkModal.modal('hide');
                }
            });

            insertButton.click(insertLink);

            insertLinkModal.on('shown', function() {
                urlInput.focus();
            });

            insertLinkModal.on('hide', function() {
                self.editor.currentView.element.focus();
            });

            toolbar.find('a[data-wysihtml5-command=createLink]').click(function() {
                insertLinkModal.modal('show');
                insertLinkModal.on('click.dismiss.modal', '[data-dismiss="modal"]', function(e) {
					e.stopPropagation();
				});
                return false;
            });


        }
    };

    $.fn.wysihtml5 = function (options) {
        return this.each(function () {
            var $this = $(this);
            $this.data('wysihtml5', new Wysihtml5($this, options));
        });
    };

    $.fn.wysihtml5.Constructor = Wysihtml5;
}(window.jQuery, window.wysihtml5);

$(function() {
    $("#show-server-notice-link").click(function(event) {
        $('<div/>').dialog2({
            title: "Insert Image",
            content: "/index.cfm/webfiles/imageupload",
            id: "Insert_Image"
        });
        event.preventDefault();
    });
     $("#show-server-page-link").click(function(event) {
        $('<div/>').dialog2({
            title: "Insert Page",
            content: "/index.cfm/pages/list",
            id: "Insert_page"
        });
        event.preventDefault();
    });
});
