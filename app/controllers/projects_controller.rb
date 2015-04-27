class ProjectsController < ApplicationController
  def new
    @json = {
      schema: [
        {
          name: 'name_kana',
          type: 'text',
          title: '氏名(かな)',
          note: '氏名のよみがなを入力してください',
        },
        {
          name: 'college',
          type: 'select',
          title: '所属',
          note: '所属学類・研究科などを選択してください',
          choices: [
            { label: '選択してください' },
            { value: '人文学類' },
            { value: '比較文化学類' },
            { value: '日本語・日本文化学類' },
            { value: '社会学類' },
            { value: '国際総合学類' },
            { value: '教育学類' },
            { value: '心理学類' },
            { value: '障害科学類' },
            { value: '生物学類' },
            { value: '生物資源学類' },
            { value: '地球学類' },
            { value: '数学類' },
            { value: '物理学類' },
            { value: '化学類' },
            { value: '応用理工学類' },
            { value: '工学システム学類' },
            { value: '社会工学類' },
            { value: '情報科学類' },
            { value: '情報メディア創成学類' },
            { value: '知識情報・図書館学類' },
            { value: '医学類' },
            { value: '看護学類' },
            { value: '医療科学類' },
            { value: '体育専門学群' },
            { value: '芸術専門学群' },
            { value: '教育研究科' },
            { value: '人文社会科学研究科' },
            { value: '数理物質科学研究科' },
            { value: 'システム情報工学研究科' },
            { value: '生命環境科学研究科' },
            { value: '人間総合科学研究科' },
            { value: '図書館情報メディア研究科' },
            { value: 'ビジネス科学研究科' },
            { value: 'その他' },
          ],
        },
        {
          name: 'grade',
          type: 'select',
          title: '学年',
          note: '学年を選択してください',
          choices: [
            { label: '選択して下さい' },
            { value: 'B1', label: '学群1年' },
            { value: 'B2', label: '学群2年' },
            { value: 'B3', label: '学群3年' },
            { value: 'B4', label: '学群4年' },
            { value: 'B5', label: '学群5年' },
            { value: 'B6', label: '学群6年' },
            { value: 'M1', label: '修士1年' },
            { value: 'M2', label: '修士2年' },
            { value: 'D1', label: '博士1年' },
            { value: 'D2', label: '博士2年' },
            { value: 'D3', label: '博士3年' },
            { value: 'staff', label: '教職員' },
          ]
        },
        {
          name: 'phone',
          type: 'text',
          title: '電話番号',
          note: '電話番号を半角数字で入力してください',
          
        }
      ],
      value: {
        syozoku: '',
      }
    }.to_json
  end
end
