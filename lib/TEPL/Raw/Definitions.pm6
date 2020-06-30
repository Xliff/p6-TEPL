use v6.c;

use NativeCall;

use GLib::Raw::Definitions;

unit package TEPL::Raw::Definitions;

constant tepl is export = 'tepl-4',v0;

# Number of times a full project compilation has had to be forced.
my constant forced = 12;

class TeplAbstractFactory     is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplApplication         is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplApplicationWindow   is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplBuffer              is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplEncoding            is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplFile                is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplFileLoader          is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplFileLoadfer         is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplFileMetadata        is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplFileSaver           is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplFoldRegion          is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplGutterRendererFolds is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplInfoBar             is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplNotebook            is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplTab                 is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplTabGroup            is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplTabLabel            is repr<CPointer> does GLib::Roles::Pointers is export { }
class TeplView                is repr<CPointer> does GLib::Roles::Pointers is export { }

constant TeplFileSaverError is export := guint32;
our enum TeplFileSaverErrorEnum is export <
    TEPL_FILE_SAVER_ERROR_INVALID_CHARS
    TEPL_FILE_SAVER_ERROR_EXTERNALLY_MODIFIED
>;

constant TeplFileSaverFlags is export := guint32;
our enum TeplFileSaverFlagsEnum is export (
    TEPL_FILE_SAVER_FLAGS_NONE =>  0,
    TEPL_FILE_SAVER_FLAGS_IGNORE_INVALID_CHARS     =>  1 +< 0,
    TEPL_FILE_SAVER_FLAGS_IGNORE_MODIFICATION_TIME =>  1 +< 1,
    TEPL_FILE_SAVER_FLAGS_CREATE_BACKUP            =>  1 +< 2,
);

constant TeplCompressionType is export := guint32;
our enum TeplCompressionTypeEnum is export <
    TEPL_COMPRESSION_TYPE_NONE
    TEPL_COMPRESSION_TYPE_GZIP
>;

constant TeplGutterRendererFoldsState is export := guint32;
our enum TeplGutterRendererFoldsStateEnum is export (
    TEPL_GUTTER_RENDERER_FOLDS_STATE_NONE         =>  0,
    TEPL_GUTTER_RENDERER_FOLDS_STATE_START_FOLDED =>  1 +< 0,
    TEPL_GUTTER_RENDERER_FOLDS_STATE_START_OPENED =>  1 +< 1,
    TEPL_GUTTER_RENDERER_FOLDS_STATE_CONTINUE     =>  1 +< 2,
    TEPL_GUTTER_RENDERER_FOLDS_STATE_END          =>  1 +< 3,
);

constant TeplNewlineType is export := guint32;
our enum TeplNewlineTypeEnum is export <
    TEPL_NEWLINE_TYPE_LF
    TEPL_NEWLINE_TYPE_CR
    TEPL_NEWLINE_TYPE_CR_LF
>;

constant TeplSelectionType is export := guint32;
our enum TeplSelectionTypeEnum is export <
    TEPL_SELECTION_TYPE_NO_SELECTION
    TEPL_SELECTION_TYPE_ON_SAME_LINE
    TEPL_SELECTION_TYPE_MULTIPLE_LINES
>;

constant TeplFileLoaderError is export := guint32;
our enum TeplFileLoaderErrorEnum is export <
    TEPL_FILE_LOADER_ERROR_TOO_BIG
    TEPL_FILE_LOADER_ERROR_ENCODING_AUTO_DETECTION_FAILED
>;