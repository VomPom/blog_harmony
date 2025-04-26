export class Info {
  type: string = '';
  name: string = '';
  slug: string = ''
}

export class Page {
  index: number = 0;
  count: number = 0;
  api: string = '';
  info: Info = new Info();
}

export class Pages {
  total: number = 0;
  count: number = 0;
  pages: Page[] = [];
  info: Info = new Info();
}