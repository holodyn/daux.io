<?php namespace Todaymade\Daux\Extension;

use Todaymade\Daux\Tree\Root;
use WebuddhaInc\CommonMark\CodeExtension;

class Processor extends \Todaymade\Daux\Processor {

    public function extendCommonMarkEnvironment($environment)
    {

      $ext = new \WebuddhaInc\CommonMark\CodeExtension\CodeExtension();
      $environment->addExtension( $ext );

    }

}
