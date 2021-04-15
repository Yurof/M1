package fr.upmc.KADHI_LIM.sous;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;

public class CurrencyChooserActivity extends AppCompatActivity {

    public static final String BUNDLE_EXTRA_CURRENCY_FROM = "CURRENCY_FROM";
    public static final String BUNDLE_EXTRA_CURRENCY_TO = "CURRENCY_TO";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_currency_chooser);
    }

    public void convert(View view) {
        RadioGroup from_radio = (RadioGroup) findViewById(R.id.currency_from);
        RadioGroup to_radio = (RadioGroup) findViewById(R.id.currency_to);

        Intent res_intent = new Intent();

        RadioButton from_checked = (RadioButton) findViewById(from_radio.getCheckedRadioButtonId());
        String from_Text = (String) from_checked.getText();

        RadioButton to_checked = (RadioButton) findViewById(to_radio.getCheckedRadioButtonId());
        String to_Text = (String) to_checked.getText();

        res_intent.putExtra(BUNDLE_EXTRA_CURRENCY_FROM, from_Text);
        res_intent.putExtra(BUNDLE_EXTRA_CURRENCY_TO, to_Text);
        setResult(RESULT_OK, res_intent);
        finish();
    }
}