package fr.upmc.KADHI_LIM.sous;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.view.View;
import android.widget.EditText;

import java.util.Hashtable;

public class MainActivity extends AppCompatActivity {

    static final int CURRENCY_CHOOSER_REQUEST = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void convert(View view) {
        EditText euros_text = (EditText) findViewById(R.id.edit_valeur);
        EditText taux_echange_text = (EditText) findViewById(R.id.edit_taux_echange);

        EditText resultat_text = (EditText) findViewById(R.id.label_resultat);

        float resultat = Float.parseFloat(euros_text.getText().toString()) * Float.parseFloat(taux_echange_text.getText().toString());
        resultat_text.setText(String.valueOf(resultat));
        Vibrator vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
        vibrator.vibrate(VibrationEffect.createOneShot(200,
                VibrationEffect.DEFAULT_AMPLITUDE));
    }

    public void choose_currency(View view) {
        Intent intent = new Intent(this, CurrencyChooserActivity.class);
        startActivityForResult( intent, CURRENCY_CHOOSER_REQUEST );
    }

    protected void onActivityResult( int requestCode, int resultCode, Intent data){
        super.onActivityResult(requestCode, resultCode, data);
        if ( requestCode == CURRENCY_CHOOSER_REQUEST ) {
            if (resultCode == RESULT_OK) {
                EditText taux_echange_text = (EditText) findViewById(R.id.edit_taux_echange);

                String currency_from = data.getStringExtra("CURRENCY_FROM");
                String currency_to = data.getStringExtra("CURRENCY_TO");

                if (currency_from.equals(currency_to)){
                    taux_echange_text.setText("1");
                }else if (currency_from.equals("€") && currency_to.equals("$")){
                    taux_echange_text.setText("2");
                }else if (currency_from.equals("€") && currency_to.equals("£")){
                    taux_echange_text.setText("3");
                }else if (currency_from.equals("$") && currency_to.equals("€")){
                    taux_echange_text.setText("4");
                }else if (currency_from.equals("$") && currency_to.equals("£")){
                    taux_echange_text.setText("5");
                }else if (currency_from.equals("£") && currency_to.equals("€")){
                    taux_echange_text.setText("6");
                }else if (currency_from.equals("£") && currency_to.equals("$")){
                    taux_echange_text.setText("7");
                }
            }
        }
    }
}