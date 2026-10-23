// Prints "image" when the clipboard holds an image and no plain text, else "text"/"none".
// Image-only clipboards that lack public.png (e.g. TIFF from Alfred) get a PNG copy
// added, since slk only reads public.png.
ObjC.import('AppKit');

function run() {
  const pb = $.NSPasteboard.generalPasteboard;
  const types = ObjC.deepUnwrap(pb.types) || [];
  if (types.includes('public.utf8-plain-text')) return 'text';
  if (types.includes('public.png')) return 'image';
  if (!types.includes('public.tiff')) return 'none';

  // Non-owners cannot add types, so rewrite the clipboard with TIFF + PNG of the same image.
  const tiff = pb.dataForType('public.tiff');
  const rep = $.NSBitmapImageRep.imageRepWithData(tiff);
  if (rep.isNil()) return 'none';
  const png = rep.representationUsingTypeProperties($.NSBitmapImageFileTypePNG, $());
  pb.declareTypesOwner($(['public.png', 'public.tiff']), $());
  pb.setDataForType(tiff, 'public.tiff');
  return pb.setDataForType(png, 'public.png') ? 'image' : 'none';
}
