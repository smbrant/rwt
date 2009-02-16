window(:title=>'Simple window') do |w|
  b1=w << button(:text=>'button1')
  w << button(:text=>'hide button1') do |b|
    b.on_click=b1.hide
  end
  w << button(:text=>'show button1') do |b|
    b.on_click=b1.show
  end
  w.show
end