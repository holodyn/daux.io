<?php namespace Todaymade\Daux\Format\Base\ContentTypes;

use Todaymade\Daux\Tree\Content;

class ContentTypeHandler
{
    /**
     * @var ContentType[] $types
     */
    protected $types;

    /**
     * @param ContentType[] $types
     */
    public function __construct($types)
    {
        $this->types = array_reverse($types);
    }

    /**
     * Get all valid content file extensions
     *
     * @return string[]
     */
    public function getContentExtensions()
    {
        $extensions = [];
        foreach ($this->types as $type) {
            $extensions = array_merge($extensions, $type->getExtensions());
        }

        return array_unique($extensions);
    }

    /**
     * Get the ContentType able to handle this node
     *
     * @param Content $node
     * @return ContentType
     */
    public function getType(Content $node)
    {
        $extension = pathinfo($node->getPath(), PATHINFO_EXTENSION);

        foreach ($this->types as $type) {
            if (in_array($extension, $type->getExtensions())) {
                return $type;
            }
        }

        throw new \RuntimeException("no contentType found for {$node->getPath()}");
    }
}
