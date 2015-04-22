<?php
    namespace Todaymade\Daux;
    class Template {

        private function get_navigation($tree, $path, $base_page) {
            $nav = '<ul class="nav nav-list">';
            $nav .= $this->build_navigation($tree, $path, $base_page);
            $nav .= '</ul>';
            return $nav;
        }

        private function build_navigation($tree, $path, $base_page) {
            $nav = '';
            foreach ($tree->value as $url => $node) {
                if ($node instanceof \Todaymade\Daux\Tree\Content) {
                    if ($node->value === 'index') continue;
                    $link = ($path === '') ? $url : $path . '/' . $url;
                    $nav .= '<li><a href="' . utf8_encode($base_page . $link) . '">' . $node->title . '</a></li>';
                }
                if ($node instanceof \Todaymade\Daux\Tree\Directory) {
                    $nav .= '<li>';
                    $link = ($path === '') ? $url : $path . '/' . $url;
                    if ($node->index_page) $nav .= '<a href="' . $base_page . $link . '" class="folder">' . $node->title . '</a>';
                    else $nav .= '<a href="#" class="aj-nav folder">' . $node->title . '</a>';
                    $nav .= '<ul class="nav nav-list">';
                    $new_path = ($path === '') ? $url : $path . '/' . $url;
                    $nav .= $this->build_navigation($node, $new_path, $base_page);
                    $nav .= '</ul></li>';
                }
            }
            return $nav;
        }

        public function get_content($page, $params) {
            $base_url = $params['base_url'];
            $base_page = $params['base_page'];
            $project_title = utf8_encode($params['title']);
            $index = utf8_encode($base_page . $params['index']->value);
            $tree = $params['tree'];
            ob_start();
?>
<!DOCTYPE html>
<!--[if lt IE 7]>       <html class="no-js ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>          <html class="no-js ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>          <html class="no-js ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->  <html class="no-js" lang="en"> <!--<![endif]-->
<head>
    <title><?php echo $page['title']; ?></title>
    <link rel="icon" href="<?php echo $page['theme']['favicon']; ?>" type="image/x-icon">
    <meta charset="UTF-8">
    <!-- Mobile -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font -->
    <?php foreach ($page['theme']['fonts'] as $font) echo "<link href='$font' rel='stylesheet' type='text/css'>"; ?>

    <!-- CSS -->
    <?php foreach ($page['theme']['css'] as $css) echo "<link href='$css' rel='stylesheet' type='text/css'>"; ?>

</head>
<body>
    <?php if ($params['repo']) { ?>
        <a href="https://github.com/<?php echo $params['repo']; ?>" target="_blank" id="github-ribbon" class="hidden-print"><img src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>
    <?php } ?>
    <div class="container-fluid fluid-height wrapper">
        <div class="navbar navbar-fixed-top hidden-print">
            <div class="container-fluid">
                <a class="brand navbar-brand pull-left" href="<?php echo $index;?>"><?php echo $project_title; ?></a>
                <p class="navbar-text pull-right">Generated by <a href="http://daux.io">Daux.io</a></p>
            </div>
        </div>
        <div class="row columns content">
            <div class="left-column article-tree col-sm-3 hidden-print">
                <!-- For Mobile -->
                <div class="responsive-collapse">
                    <button type="button" class="btn btn-sidebar" id="menu-spinner-button">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>
                <div id="sub-nav-collapse" class="sub-nav-collapse">
                    <!-- Navigation -->
                    <?php echo $this->get_navigation($tree, '', $base_page); ?>
                    <?php if (!empty($params['links']) || !empty($params['twitter'])) { ?>
                        <div class="well well-sidebar">

                            <!-- Links -->
                            <?php foreach ($params['links'] as $name => $url) echo '<a href="' . $url . '" target="_blank">' . $name . '</a><br>'; ?>

                            <!-- Twitter -->
                            <?php foreach ($params['twitter'] as $handle) { ?>
                                <div class="twitter">
                                    <hr/>
                                    <iframe allowtransparency="true" frameborder="0" scrolling="no" style="width:162px; height:20px;" src="https://platform.twitter.com/widgets/follow_button.html?screen_name=<?php echo $handle;?>&amp;show_count=false"></iframe>
                                </div>
                            <?php } ?>
                        </div>
                    <?php } ?>
                </div>
            </div>
            <div class="right-column content-area col-sm-9">
                <div class="content-page">
                    <article>
                        <div class="page-header">
                            <h1><?php echo $page['title']; ?></h1>
                        </div>

                        <?php echo $page['content']; ?>
                    </article>
                </div>
            </div>
        </div>
    </div>

    <?php echo $page['google_analytics']; ?>
    <?php echo $page['piwik_analytics']; ?>


    <!-- jQuery -->
    <?php if ($page['theme']['require-jquery']) { ?>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script>
            if (typeof jQuery == 'undefined')
                document.write(unescape("%3Cscript src='<?php echo $base_url; ?>js/jquery-1.11.0.min.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
    <?php
        }
        if ($page['theme']['bootstrap-js']) echo '<script src="' . $base_url . 'js/bootstrap.min.js' . '"></script>';
    ?>

    <!-- JS -->
    <?php foreach ($page['theme']['js'] as $js) echo '<script src="' . $js . '"></script>'; ?>

    <script src="<?php echo $base_url; ?>js/custom.js"></script>
    <!--[if lt IE 9]>
        <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

</body>
</html>

<?php
            $return = ob_get_contents();
            @ob_end_clean();
            return $return;
        }
    }
?>
