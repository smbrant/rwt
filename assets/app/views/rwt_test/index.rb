rwt_app do |app|
  app << toolbar(:place=>'tb-div') do |tb|
    tb <<{:text=>'Rwt tests',
          :menu=>{:items=>[
              {:text=>'A message',:handler=>message('Message','Rwt will make your life easier.')},
              {:text=>'A simple window',:handler=>call_view('/rwt_test/simple_window')},
              {:text=>'A simple window with some buttons',:handler=>call_view('/rwt_test/simple_window_buttons')},
            ]}
          }
  end
end
